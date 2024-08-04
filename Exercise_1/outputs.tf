output "C2_TeamServer_IPv4" {
  value = aws_eip.C2_TeamServer_eip.*.public_ip # Because aws_instance.ubuntu has "count" set, its attributes must be accessed on specific instances in ec2.tf file (soon instances.tf), we must set '[*]' to avoid TF Error: Missing resource instance key ; Indices: aws_instance.ubuntu[count.index]
}

output "C2_Redirector_IPv4" {
  value = aws_eip.C2_Redirector_eip.*.public_ip # Because aws_instance.ubuntu has "count" set, its attributes must be accessed on specific instances in ec2.tf file (soon instances.tf), we must set '[*]' to avoid TF Error: Missing resource instance key ; Indices: aws_instance.ubuntu[count.index]
}
