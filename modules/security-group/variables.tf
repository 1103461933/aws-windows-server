variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group for Windows EC2 instance"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "allow_rdp" {
  description = "Whether to allow RDP access"
  type        = bool
  default     = true
}

variable "rdp_config" {
  description = "RDP port configuration"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  })
  default = {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    description = "RDP access"
  }
}

variable "allowed_rdp_cidr_blocks" {
  description = "List of CIDR blocks allowed for RDP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_rdp_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR blocks allowed for RDP access"
  type        = list(string)
  default     = []
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
  description = "Additional ingress rules beyond RDP"
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}