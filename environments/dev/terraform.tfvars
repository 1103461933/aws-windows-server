# ============================================
# CONFIGURACIÓN GENERAL
# ============================================
aws_region   = "us-east-2"
environment  = "dev"
project_name = "windows-ec2"



# ============================================
# CONFIGURATION EC2 INSTANCE
# ============================================
key_name      = "dev-key-pair"
instance_type = "t3.medium"
associate_eip = false
enable_termination_protection = false

# ============================================
# CONFIGURATION ROOT VOLUME
# ============================================
root_volume_config = {
  type       = "gp3"
  size       = 50
  encrypted  = true
  iops       = 3000
  throughput = 125
}

# ============================================
# ADITINAL VOLUMES
# ============================================
additional_volumes = []

# ============================================
# CONFIGURATION SECURITY GROUPS
# ============================================
security_group_name = "windows-rdp-dev"
allowed_rdp_cidr_blocks = ["0.0.0.0/0"]
rdp_port = 3389

# RULES (egress)
egress_rules = [
  {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    description      = "Allow HTTP outbound"
  },
  {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    description      = "Allow HTTPS outbound"
  },
  {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    protocol         = "tcp"
    from_port        = 3389
    to_port          = 3389
    description      = "Allow RDP outbound"
  },
  {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    protocol         = "udp"
    from_port        = 53
    to_port          = 53
    description      = "Allow DNS outbound"
  },
  {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    protocol         = "tcp"
    from_port        = 53
    to_port          = 53
    description      = "Allow DNS-TCP outbound"
  },
  {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    protocol         = "udp"
    from_port        = 123
    to_port          = 123
    description      = "Allow NTP outbound"
  },
  {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    protocol         = "tcp"
    from_port        = 5985
    to_port          = 5986
    description      = "Allow WinRM outbound"
  },
  {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    protocol         = "icmp"
    from_port        = -1
    to_port          = -1
    description      = "Allow ICMP outbound (ping)"
  }
]

# INGRESS RULES 
ingress_rules = []

# ============================================
# CONFIGURATION S3 BUCKET
# ============================================
bucket_name_prefix       = "bucket-911"
enable_bucket_versioning = true
enable_bucket_encryption = true

# LIFECYCLE RULES
bucket_lifecycle_rules = []

# ============================================
# TAGS (LABELS)
# ============================================
tags = {
  CostCenter = "Development"
  Owner      = "DevOps-Team"
  Purpose    = "Windows Server Testing"
}