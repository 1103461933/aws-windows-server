# General Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

# Networking Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones to use"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
}

variable "use_public_subnet" {
  description = "Use public subnet for the instance (true) or private subnet (false)"
  type        = bool
}

# EC2 Variables
variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "root_volume_config" {
  description = "Root volume configuration"
  type = object({
    type      = string
    size      = number
    encrypted = bool
    iops      = number
    throughput = number
  })
}

variable "additional_volumes" {
  description = "Additional EBS volumes"
  type = list(object({
    device_name = string
    volume_type = string
    volume_size = number
    encrypted   = bool
    iops        = number
    throughput  = number
  }))
  default = []
}

variable "associate_eip" {
  description = "Associate Elastic IP with instance"
  type        = bool
}

variable "enable_termination_protection" {
  description = "Enable termination protection"
  type        = bool
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
}

variable "cpu_credits" {
  description = "CPU credits for burstable instances"
  type        = string
}

# Security Group Variables
variable "security_group_name" {
  description = "Security group name"
  type        = string
}

variable "allowed_rdp_cidr_blocks" {
  description = "CIDR blocks allowed for RDP access"
  type        = list(string)
}

variable "allowed_rdp_ipv6_cidr_blocks" {
  description = "IPv6 CIDR blocks allowed for RDP access"
  type        = list(string)
  default     = []
}

variable "rdp_port" {
  description = "RDP port number"
  type        = number
}

variable "egress_rules" {
  description = "Egress rules configuration"
  type = list(object({
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    protocol         = string
    from_port        = number
    to_port          = number
    description      = string
  }))
}

variable "ingress_rules" {
  description = "Additional ingress rules"
  type = list(object({
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    protocol         = string
    from_port        = number
    to_port          = number
    description      = string
  }))
  default = []
}

# S3 Bucket Variables
variable "bucket_name_prefix" {
  description = "Prefix for S3 bucket name"
  type        = string
}

variable "enable_bucket_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
}

variable "enable_bucket_encryption" {
  description = "Enable S3 bucket encryption"
  type        = bool
}

variable "encryption_algorithm" {
  description = "Encryption algorithm (AES256 or aws:kms)"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID for S3 encryption"
  type        = string
  default     = null
}

variable "bucket_lifecycle_rules" {
  description = "Lifecycle rules for S3 bucket"
  type = list(object({
    enabled = bool
    id      = string
    expiration = optional(object({
      days = number
    }))
    transition = optional(list(object({
      days          = number
      storage_class = string
    })))
    noncurrent_version_expiration = optional(object({
      days = number
    }))
  }))
  default = []
}

variable "block_public_acls" {
  description = "Block public ACLs"
  type        = bool
}

variable "block_public_policy" {
  description = "Block public policies"
  type        = bool
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs"
  type        = bool
}

variable "restrict_public_buckets" {
  description = "Restrict public buckets"
  type        = bool
}

# Monitoring Variables
variable "enable_cpu_alarm" {
  description = "Enable CPU alarm"
  type        = bool
}

variable "cpu_alarm_threshold" {
  description = "CPU alarm threshold percentage"
  type        = number
}

variable "alarm_actions" {
  description = "SNS topics for alarm actions"
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}