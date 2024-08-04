# Create a local file containing a shell script to update the AWS EC2 instance hostnames. In the case of this configuration, if this step is not applied, all EC2 VMs will end up named "kali" given that is the default hostname of the AWS AMI we're deploying from.
resource "local_file" "update_aws_ec2_hostnames" {
  content  = <<-EOT
  #!/bin/bash

  # Check if the script is run as root
  if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." 
    exit 1
  fi

  # Check if both old and new hostnames are provided as arguments
  if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <old_hostname> <new_hostname>"
    exit 1
  fi

  old_hostname="$1"
  new_hostname="$2"

  # Update /etc/hosts file
  sed -i "s/$old_hostname/$new_hostname/g" /etc/hosts

  # Update /etc/hostname file
  echo "$new_hostname" > /etc/hostname

  # Update the current hostname
  hostnamectl set-hostname "$new_hostname"

  echo "Hostname updated from $old_hostname to $new_hostname."

  # Restart the system (optional)
  # Uncomment the line below if you want to restart the system after updating the hostname.
  # reboot now

  EOT
  filename = "${path.root}/update_aws_ec2_hostnames.sh"
}

# Create an AWS EC2 instance
resource "aws_instance" "C2_TeamServer" {
  # Kali Linux is provisioned via [Amazon Machine Images (AMI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) using [ami attribute of Terraform resource provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#ami)
  ami = var.use1_ami_kali_234
  # [EC2 Instance type](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html) is defined using a [variable `instance_type_C2_server` declared in `variables.tf` file](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#instance_type) and assigned to the `instance_type` attribute.
  instance_type = var.instance_type_C2_server
  key_name      = aws_key_pair.key_pair.key_name
  # The traffic allowed to ingress and egress the EC2 instance is controlled via [AWS Security Groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/security-group-rules.html) attached to the [default VPC in the region](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-vpc.html).
  # SG ID value is assigned to [`vpc_security_group_ids`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#vpc_security_group_ids)
  vpc_security_group_ids = [aws_security_group.C2_TeamServer_SG.id]
  # Count attribute defines the number of EC2 instances that are created. Change this when we want to add more machines and add [count.index] to `subnet_id` and `private_ip` attributes in this resource block.
  count     = 1
  subnet_id = aws_subnet.prod-subnet-public-1.id
  # The [`private_ip`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#private_ip) attribute assigned the [RFC1918 ip addresses](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-instance-addressing.html#concepts-private-addresses) to the resources created. 
  # Ensure this IP exists in the VPC subnet and it is available. 
  private_ip                  = var.list_private_ips_C2_teamservers[count.index]
  associate_public_ip_address = true
  # EC2 instance will only allow access to its metadata using the more secure IMDSv2. 
  # This security measure helps mitigate certain types of attacks that exploit the less secure IMDSv1.
  metadata_options {
    http_tokens                 = "required" # Enforce the use of IMDSv2; It means that the instance metadata must be accessed using a session token, which is a feature of IMDSv2. IMDSv1, which does not support session tokens, is effectively disabled with this setting.
    http_put_response_hop_limit = 1          # Recommended setting for IMDSv2. This setting defines the number of allowed network hops to reach the instance metadata service. The value 1 means that only the instance itself can access its own metadata. This is a security best practice to prevent SSRF attacks.
  }

  root_block_device {
    volume_size = var.volume_size_C2_teamserver
  }
  # Use this `${count.index + 0}` when making multiple instances

  tags = {
    Name = "C2-TeamServer-${count.index + 0}"
  }

  # Working ansible-playbook command: `"sleep 90; export ANSIBLE_HOST_KEY_CHECKING=false; ansible-playbook -i 'IPv4,' --private-key [Environment]_[Application]_[Region]_[Role]_[Date]_[UniqueID] 'ansible/C2_TeamServer_playbook.yml' --extra-vars 'kali' "]`
  #  provisioner "local-exec" {
  #    command = "sleep 90; export ANSIBLE_HOST_KEY_CHECKING=false; ansible-playbook -i '${self.public_ip},' --private-key ${aws_key_pair.key_pair.key_name}.pem 'ansible/C2_TeamServer_playbook.yml' --extra-vars '${var.ansible_become}' "
  #  }
  #   Use the file provisioner to copy the hostname update script to the instance
  provisioner "file" {
    source      = local_file.update_aws_ec2_hostnames.filename
    destination = "/tmp/update_aws_ec2_hostnames.sh" # Destination path on the instance
    connection {
      host        = self.public_ip # Use the public IP address of the instance
      type        = "ssh"
      user        = var.kali_ansible_become_user
      private_key = file("${aws_key_pair.key_pair.key_name}.pem")
      # private_key = file("${var.use1_az4_private_key}.pem") # [Syntax for this attribute was specially problematic. Reference answer](https://stackoverflow.com/a/76766295/9430327)
    }
  }

  # Use the remote-exec provisioner to set the hostname
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/update_aws_ec2_hostnames.sh",
      "new_hostname=\"C2-TeamServer-${count.index + 0}\"",
      "sudo /tmp/update_aws_ec2_hostnames.sh $(cat /etc/hostname) $new_hostname"
    ]
    connection {
      host        = self.public_ip # Use the public IP address of the instance
      type        = "ssh"
      user        = var.kali_ansible_become_user
      private_key = file("${aws_key_pair.key_pair.key_name}.pem")
      # private_key = file("${var.use1_az4_private_key}.pem")
    }
  }
}

resource "aws_eip" "C2_TeamServer_eip" {
  count    = 1
  instance = aws_instance.C2_TeamServer[count.index].id
  # vpc      = true # This attribute is deprecated but leaving here for reference
}

resource "aws_instance" "C2_Redirector" {
  # Kali Linux is provisioned via [Amazon Machine Images (AMI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) using [ami attribute of Terraform resource provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#ami)
  ami = var.use1_ami_kali_234 # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html ; https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#ami
  # [EC2 Instance type](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html) is defined using a [variable `instance_type_C2_server` declared in `variables.tf` file](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#instance_type) and assigned to the `instance_type` attribute.
  instance_type = var.instance_type_C2_redirector # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html ; https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#instance_type
  key_name      = aws_key_pair.key_pair.key_name
  # The traffic allowed to ingress and egress the EC2 instance is controlled via [AWS Security Groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/security-group-rules.html) attached to the [default VPC in the region](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-vpc.html).
  # SG ID value is assigned to [`vpc_security_group_ids`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#vpc_security_group_ids)
  vpc_security_group_ids = [aws_security_group.C2_Redirector_SG.id] # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/security-group-rules.html ; https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#vpc_security_group_ids
  # Count attribute defines the number of EC2 instances that are created. Change this when we want to add more machines and add [count.index] to `subnet_id` and `private_ip` attributes in this resource block.
  count     = 1 # Change this when we want to add more machines and add [count.index] to `subnet_id` and `private_ip` attributes in this resource block.
  subnet_id = aws_subnet.prod-subnet-public-1.id
  # The [`private_ip`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#private_ip) attribute assigned the [RFC1918 ip addresses](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-instance-addressing.html#concepts-private-addresses) to the resources created. 
  # Ensure this IP exists in the VPC subnet and it is available. 
  private_ip                  = var.list_private_ips_C2_Redirectors[count.index] # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-instance-addressing.html#concepts-private-addresses ; https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#private_ip
  associate_public_ip_address = true
  # EC2 instance will only allow access to its metadata using the more secure IMDSv2. 
  # This security measure helps mitigate certain types of attacks that exploit the less secure IMDSv1.
  metadata_options {
    http_tokens                 = "required" # Enforce the use of IMDSv2; It means that the instance metadata must be accessed using a session token, which is a feature of IMDSv2. IMDSv1, which does not support session tokens, is effectively disabled with this setting.
    http_put_response_hop_limit = 1          # Recommended setting for IMDSv2. This setting defines the number of allowed network hops to reach the instance metadata service. The value 1 means that only the instance itself can access its own metadata. This is a security best practice to prevent SSRF attacks.
  }

  root_block_device {
    volume_size = var.volume_size_C2_redirector
  }
  # Use this `${count.index + 0}` when making multiple instances
  tags = {
    Name = "C2-Redirector-${count.index + 0}" #Use this when making multiple instances
  }

  # Remove access to port 80/TCP once TLS certificate is applied to the machine via ansible playbook
  #  provisioner "local-exec" {
  #    command = "aws ec2 revoke-security-group-ingress --group-id ${aws_security_group.C2_Redirector_SG.id} --protocol tcp --port 80 --cidr 0.0.0.0/0 && aws ec2 revoke-security-group-ingress --group-id ${aws_security_group.C2_Redirector_SG.id} --protocol tcp --port 443 --cidr 0.0.0.0/0"
  #  }

  # Working ansible-playbook command: `"sleep 90; export ANSIBLE_HOST_KEY_CHECKING=false; ansible-playbook -i 'IPv4,' --private-key [Environment]_[Application]_[Region]_[Role]_[Date]_[UniqueID] 'ansible/C2_Redirector_playbook.yml' --extra-vars 'kali' "]`
  #  provisioner "local-exec" {
  #    command = "sleep 90; export ANSIBLE_HOST_KEY_CHECKING=false; ansible-playbook -i '${self.public_ip},' --private-key ${aws_key_pair.key_pair.key_name}.pem 'ansible/C2_Redirector_playbook.yml' --extra-vars '${var.ansible_become}' "
  #  }

  # Use the file provisioner to copy the hostname update script to the instance
  provisioner "file" {
    source      = local_file.update_aws_ec2_hostnames.filename
    destination = "/tmp/update_aws_ec2_hostnames.sh" # Destination path on the instance
    connection {
      host        = self.public_ip # Use the public IP address of the instance
      type        = "ssh"
      user        = var.kali_ansible_become_user
      private_key = file("${aws_key_pair.key_pair.key_name}.pem")
      # private_key = file("${var.use1_az4_private_key}.pem") # [Syntax for this attribute was specially problematic. Reference answer](https://stackoverflow.com/a/76766295/9430327)
    }
  }

  # Use the remote-exec provisioner to set the hostname
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/update_aws_ec2_hostnames.sh",
      "new_hostname=\"C2-Redirector-${count.index}\"",
      "sudo /tmp/update_aws_ec2_hostnames.sh $(cat /etc/hostname) $new_hostname"
    ]
    connection {
      host        = self.public_ip # Use the public IP address of the instance
      type        = "ssh"
      user        = var.kali_ansible_become_user
      private_key = file("${aws_key_pair.key_pair.key_name}.pem")
      # private_key = file("${var.use1_az4_private_key}.pem")
    }
  }
}

# Service Quota to increase this AWS Elastic IP soft-limit from 5 is approved (01/16/2024) request ID: d54a2e1066d140c1905751f294787c3f4TeZMIX2

resource "aws_eip" "C2_Redirector_eip" {
  count    = 1
  instance = aws_instance.C2_Redirector[count.index].id
  # vpc      = true # This attribute is deprecated but leaving here for reference
}

# The local_file resource block creates a local file named apply_ansible_playbook_to_redirectors.sh with the content derived from the local.redirector_public_IPs local value.
# It has a dependency on the aws_instance.C2_Redirector resource, ensuring it is created or modified before generating the file.
# The content of the file is generated using a for expression to iterate over each item in local.redirector_public_IPs.
# For each item, it passes the IP address to the "ansible-playbook -i" argument (inventory).
# The resulting content will have one `ansible-playbook` command with each public IP.
# By using the depends_on attribute, we ensure that the local_file resource waits for the aws_instance.C2_Redirector resource to be ready before generating the file.

# resource "local_file" "apply_ansible_playbook_to_teamservers" {
#   depends_on = [local.C2_TeamServer_public_ips]
#   content    = <<-EOT
#   #!/bin/bash
#   %{for item in local.C2_TeamServer_public_ips~}
#   export ANSIBLE_HOST_KEY_CHECKING=false
#   ansible-playbook -i '${item.ip}, ' \
#   --private-key "${aws_key_pair.key_pair}" \
#   'ansible/C2_TeamServer_playbook.yml' \
#   --extra-vars '${var.ansible_become}' 2>1 &
#   %{endfor~}
#   wait
#   EOT
#   filename   = "${path.root}/apply_ansible_playbook_to_teamservers.sh"
# }
