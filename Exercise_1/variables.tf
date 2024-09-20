### AWS Provider Region 

variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

### AWS Access and Secret key

variable "AWS_ACCESS_KEY" {
  type    = string
  default = "AKIXXXXXXXXX"
}

variable "AWS_SECRET_KEY" {
  type    = string
  default = "M5XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}

### EC2 Instance AMI ID

variable "use1_ami_kali_234" {
  type    = string
  default = "ami-02d46314883bdd49c"
  # For Kali Ami Alias: /aws/service/marketplace/prod-tsqyof4l3a3aa/kali-linux-2023.2 @ https://aws.amazon.com/marketplace/pp/prodview-fznsw3f7mq7to
  # For ubuntu: ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230216 - ami-01fb4901e7405cd3d - us-west-1 (N. California) @ https://cloud-images.ubuntu.com/locator/ec2/
}

### EC2 Instance Volume Size in GB
variable "volume_size_C2_redirector" {
  type    = string
  default = "32" # GB disk size for C2 redirector
}
### EC2 Instance Volume Size in GB
variable "volume_size_C2_teamserver" {
  type    = string
  default = "64" # GB disk size for C2 server
}
### AWS EC2 Instance Type check https://aws.amazon.com/ec2/instance-types/ for more
variable "instance_type_C2_redirector" {
  type    = string
  default = "i3.large" # https://aws.amazon.com/ec2/instance-types/i3/ - 4 vCPU, 16GB RAM, 10GBPs Network
}
### AWS EC2 Instance Type check https://aws.amazon.com/ec2/instance-types/ for more
variable "instance_type_C2_server" {
  type    = string
  default = "i3.large" # https://aws.amazon.com/ec2/instance-types/i3/ - 4 vCPU, 16GB RAM, 10GBPs Network
}

variable "list_private_ips_C2_teamservers" {
  description = "List of Private IPs for the C2 TeamServer instances in "
  type        = list(string)
  default = [
    "172.31.16.80"
  ]
}
### AWS EC2 Private IP "IPv4"- Make sure it exists in the subnet prior to running terraform
variable "list_private_ips_C2_Redirectors" {
  description = "List of Private IPs for the C2 Redirector instances"
  type        = list(string)
  default = [
    "172.31.16.82",
    "172.31.16.83"
  ]
}
# Availability Zone Variable
#
#----------------------------------
variable "AVAILABILITY_ZONE" {
  description = "The AWS availability zone"
  type        = string
  default     = "us-east-1a" # You can set a default value or remove this line to require explicit assignment

  validation {
    condition     = contains(["us-east-1a", "us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"], var.AVAILABILITY_ZONE)
    error_message = "The availability zone must be one of: us-west-2a, us-west-2b, us-west-2c, us-west-2d."
  }
}

# Resource Definition
#
#----------------------------------
resource "random_string" "random1" {
  length           = 16
  special          = true
  override_special = "_+"
}

resource "random_string" "resource_code" {
  length  = 10
  special = false
  upper   = false
}

variable "allowlist_open_inet" {
  type    = string
  default = "0.0.0.0/0" # Source IP
  #  sensitive = true
}
variable "allowlist_cidr" {
  type    = string
  default = "X.X.X.X/32" # Source IP
  #  sensitive = true
}

variable "ansible_become" { # Remember to assign value to sensitive TF_VAR become password with 'export ansible_become=kali' 
  description = "Ansible Become Kali Password"
  type        = string
  default     = "kali"
  #  sensitive   = true
}
variable "ubuntu_ansible_become_user" { # Remember to assign value to sensitive TF_VAR become password with 'export ansible_become_user=ubuntu' 
  description = "Ansible Become User - OS low-privileged user"
  type        = string
  default     = "ubuntu"
  #sensitive   = true
}
variable "kali_ansible_become_user" { # Remember to assign value to sensitive TF_VAR become password with 'export ansible_become_user=kali' 
  description = "Ansible Become User - OS low-privileged user"
  type        = string
  default     = "kali"
  #sensitive   = true
}
