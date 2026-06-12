# ============================================
# PRODUCTION ENVIRONMENT CONFIGURATION
# ============================================

# General Configuration
aws_region   = "us-east-2"
environment  = "prod"
project_name = "windows-ec2"

# Networking Configuration
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]
enable_nat_gateway   = true          
use_public_subnet    = false        

# EC2 Configuration
key_name             = "prod-key-pair"     
instance_type        = "t3.xlarge"
associate_eip        = true                
enable_termination_protection = true
enable_detailed_monitoring = true
cpu_credits          = "standard"

# Root Volume Configuration
root_volume_config = {
  type       = "gp3"
  size       = 100
  encrypted  = true
  iops       = 3000
  throughput = 250
}

# Additional Volumes for production
additional_volumes = [
  {
    device_name = "/dev/sdb"
    volume_type = "gp3"
    volume_size = 200
    encrypted   = true
    iops        = 3000
    throughput  = 250
  },
  {
    device_name = "/dev/sdc"
    volume_type = "gp3"
    volume_size = 100
    encrypted   = true
    iops        = 3000
    throughput  = 125
  }
]

# Security Group Configuration
security_group_name = "windows-rdp-prod"

# RESTRICT RDP ACCESS - ONLY YOUR OFFICE/VPN CIDR
allowed_rdp_cidr_blocks = [
  "203.0.113.0/24",     
  "198.51.100.50/32"     
]
rdp_port = 3389

# Egress Rules - Restrictive for production
egress_rules = [
  {
    cidr_blocks      = ["10.0.0.0/8"]
    ipv6_cidr_blocks = []
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    description      = "Allow HTTPS to internal resources"
  },
  {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    description      = "Allow HTTPS to internet for updates"
  }
]

# S3 Bucket Configuration
bucket_name_prefix       = "myapp-production-data"
enable_bucket_versioning = true
enable_bucket_encryption = true
encryption_algorithm     = "aws:kms"
kms_key_id              = "arn:aws:kms:us-east-1:123456789012:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  # Replace with your KMS key

# S3 Security
block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true

# S3 Lifecycle Rules - 7-year retention
bucket_lifecycle_rules = [
  {
    enabled = true
    id      = "transition-to-ia"
    expiration = null
    transition = [
      {
        days          = 30
        storage_class = "STANDARD_IA"
      },
      {
        days          = 90
        storage_class = "GLACIER"
      }
    ]
    noncurrent_version_expiration = {
      days = 90
    }
  },
  {
    enabled = true
    id      = "expire-old-versions"
    expiration = {
      days = 2555
    }
    transition = []
    noncurrent_version_expiration = {
      days = 2555
    }
  }
]

# Monitoring Configuration
enable_cpu_alarm     = true
cpu_alarm_threshold  = 75
alarm_actions = [
  "arn:aws:sns:us-east-1:123456789012:production-alerts"  
]

# Tags
tags = {
  CostCenter      = "Finance"
  Owner           = "Platform-Team"
  Environment     = "Production"
  Compliance      = "HIPAA"
  DataSensitivity = "High"
  BackupPolicy    = "Daily"
  PatchWindow     = "Sunday-0200"
  Contact         = "oncall@company.com"
}