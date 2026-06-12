output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.this.private_ip
}

output "public_dns" {
  description = "Public DNS name of the instance"
  value       = aws_instance.this.public_dns
}

output "elastic_ip" {
  description = "Elastic IP address (if enabled)"
  value       = try(aws_eip.this[0].public_ip, null)
}

output "ami_id" {
  description = "AMI ID used for the instance"
  value       = aws_instance.this.ami
}

output "availability_zone" {
  description = "Availability zone of the instance"
  value       = aws_instance.this.availability_zone
}

output "key_name" {
  description = "Key pair name used for the instance"
  value       = aws_instance.this.key_name
}