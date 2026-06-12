variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ami_filters" {
  description = "Filters for Windows AMI"
  type = object({
    owners      = list(string)
    name_filter = list(string)
  })
  default = {
    owners      = ["amazon"]
    name_filter = ["Windows_Server-2022-English-Full-Base-*"]
  }
}

variable "key_name" {
  description = "Name of the EC2 key pair for RDP password decryption"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be deployed"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID to attach to the instance"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = true
}

variable "associate_eip" {
  description = "Whether to associate an Elastic IP (ensures persistent IP)"
  type        = bool
  default     = false
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
    type       = "gp3"
    size       = 50
    encrypted  = true
    iops       = 3000
    throughput = 125
  }
}

variable "additional_volumes" {
  description = "Additional EBS volumes to attach"
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

variable "user_data_script" {
  description = "Custom user data script for Windows instance"
  type        = string
  default     = null
}

variable "enable_user_data" {
  description = "Enable custom user data"
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "Enable termination protection"
  type        = bool
  default     = false
}

variable "monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = true
}

variable "credit_specification" {
  description = "CPU credit specification for burstable instances"
  type = object({
    cpu_credits = string
  })
  default = {
    cpu_credits = "standard"
  }
}

variable "metadata_options" {
  description = "Metadata options for the instance"
  type = object({
    http_endpoint               = string
    http_tokens                 = string
    http_put_response_hop_limit = number
  })
  default = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

