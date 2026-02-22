output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.app_server[*].id
}

output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.app_server[*].public_ip
}

output "instance_private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = aws_instance.app_server[*].private_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.app_sg.id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = aws_security_group.app_sg.name
}

output "ami_id" {
  description = "AMI ID used for instances"
  value       = data.aws_ami.amazon_linux_2.id
}
