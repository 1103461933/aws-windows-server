# General Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "windows-ec2"
}

# EC2 Variables
variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "dev-key-pair"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
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
  default = {
    type      = "gp3"
    size      = 50
    encrypted = true
    iops      = 3000
    throughput = 125
  }
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
  default     = false
}

variable "enable_termination_protection" {
  description = "Enable termination protection"
  type        = bool
  default     = false
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = true
}

# Security Group Variables
variable "security_group_name" {
  description = "Security group name"
  type        = string
  default     = "windows-rdp-dev"
}

variable "allowed_rdp_cidr_blocks" {
  description = "CIDR blocks allowed for RDP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_rdp_ipv6_cidr_blocks" {
  description = "IPv6 CIDR blocks allowed for RDP access"
  type        = list(string)
  default     = []
}

variable "rdp_port" {
  description = "RDP port number"
  type        = number
  default     = 3389
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
  default = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      description      = "Allow all outbound traffic"
    }
  ]
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
  default     = "myapp-dev-data"
}

variable "enable_bucket_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "enable_bucket_encryption" {
  description = "Enable S3 bucket encryption"
  type        = bool
  default     = true
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

# Tags
variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
