provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(var.tags, {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = var.project_name
    })
  }
}

# Networking Module
module "networking" {
  source = "../../modules/networking"

  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  availability_zones    = var.availability_zones
  create_igw            = true
  enable_nat_gateway    = var.enable_nat_gateway

  tags = {
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

module "security_group" {
  source = "../../modules/security-group"

  security_group_name = var.security_group_name
  description         = "Security group for Windows EC2 instance - ${var.environment}"
  vpc_id              = module.networking.vpc_id
  allow_rdp           = true
  
  rdp_config = {
    from_port   = var.rdp_port
    to_port     = var.rdp_port
    protocol    = "tcp"
    description = "RDP access"
  }
  
  allowed_rdp_cidr_blocks      = var.allowed_rdp_cidr_blocks
  allowed_rdp_ipv6_cidr_blocks = var.allowed_rdp_ipv6_cidr_blocks
  egress_rules                  = var.egress_rules
  ingress_rules                 = var.ingress_rules

  tags = {
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

module "s3_bucket" {
  source = "../../modules/s3-bucket"

  bucket_name        = "${var.bucket_name_prefix}-${var.environment}-${random_id.bucket_suffix.hex}"
  enable_versioning  = var.enable_bucket_versioning
  enable_encryption  = var.enable_bucket_encryption
  encryption_algorithm = var.encryption_algorithm
  kms_key_id         = var.kms_key_id
  lifecycle_rules    = var.bucket_lifecycle_rules
  block_public_acls  = var.block_public_acls
  block_public_policy = var.block_public_policy
  ignore_public_acls  = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  tags = {
    Environment = var.environment
    Compliance  = "HIPAA"
    DataClass   = "Confidential"
  }
}

module "windows_instance" {
  source = "../../modules/windows-instance"

  instance_name       = "${var.project_name}-windows-${var.environment}"
  instance_type       = var.instance_type
  key_name            = var.key_name
  subnet_id           = var.use_public_subnet ? module.networking.public_subnet_ids[0] : module.networking.private_subnet_ids[0]
  security_group_id   = module.security_group.security_group_id
  associate_public_ip = var.use_public_subnet
  associate_eip       = var.associate_eip
  root_volume_config  = var.root_volume_config
  additional_volumes  = var.additional_volumes
  disable_api_termination = var.enable_termination_protection
  monitoring          = var.enable_detailed_monitoring

  credit_specification = {
    cpu_credits = var.cpu_credits
  }

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tags = {
    Environment = var.environment
    Compliance  = "HIPAA"
    Backup      = "Required"
    PatchGroup  = "Production"
  }
}

# CloudWatch Alarm for production monitoring
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = var.enable_cpu_alarm ? 1 : 0

  alarm_name          = "${var.project_name}-high-cpu-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = var.alarm_actions

  dimensions = {
    InstanceId = module.windows_instance.instance_id
  }

  tags = {
    Environment = var.environment
  }
}