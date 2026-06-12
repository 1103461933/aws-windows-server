# VPC Information (usando VPC por defecto)
output "vpc_info" {
  description = "VPC information"
  value = {
    vpc_id         = data.aws_vpc.default.id
    vpc_cidr       = data.aws_vpc.default.cidr_block
    subnet_id      = data.aws_subnets.default.ids[0]
    subnet_cidr    = data.aws_subnet.selected.cidr_block
    availability_zone = data.aws_subnet.selected.availability_zone
  }
}

# Windows Instance Outputs
output "windows_instance" {
  description = "Windows instance information"
  value = {
    instance_id = module.windows_instance.instance_id
    public_ip   = module.windows_instance.public_ip
    private_ip  = module.windows_instance.private_ip
    public_dns  = module.windows_instance.public_dns
    instance_type = var.instance_type
  }
}

output "windows_instance_public_ip" {
  description = "Public IP address of the Windows instance"
  value       = module.windows_instance.public_ip
}

output "windows_instance_private_ip" {
  description = "Private IP address of the Windows instance"
  value       = module.windows_instance.private_ip
}

output "windows_instance_id" {
  description = "ID of the Windows EC2 instance"
  value       = module.windows_instance.instance_id
}

output "rdp_connection" {
  description = "RDP connection details"
  value = {
    public_ip       = module.windows_instance.public_ip
    private_ip      = module.windows_instance.private_ip
    public_dns      = module.windows_instance.public_dns
    rdp_port        = var.rdp_port
    username        = local.admin_username
    password        = local.admin_password
    connect_command = "mstsc /v:${module.windows_instance.public_ip}:${var.rdp_port}"
  }
  sensitive = true
}

output "local_admin_credentials" {
  description = "Local administrator credentials"
  value = {
    username = local.admin_username
    password = local.admin_password
  }
  sensitive = true
}

output "s3_bucket" {
  description = "S3 bucket information"
  value = {
    bucket_name = module.s3_bucket.bucket_id
    bucket_arn  = module.s3_bucket.bucket_arn
  }
}

output "security_group" {
  description = "Security group information"
  value = {
    id   = module.security_group.security_group_id
    name = module.security_group.security_group_name
  }
}

output "console_links" {
  description = "AWS Console links"
  value = {
    ec2 = "https://${var.aws_region}.console.aws.amazon.com/ec2/home?region=${var.aws_region}#InstanceDetails:instanceId=${module.windows_instance.instance_id}"
    s3  = "https://s3.console.aws.amazon.com/s3/buckets/${module.s3_bucket.bucket_id}?region=${var.aws_region}"
  }
}