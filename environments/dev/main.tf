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

# Locals para configuración de usuario local
locals {
  admin_username = "admin-local"
  admin_password = "Windows2026!"
  
  user_data_script = <<-POWERSHELL
    <powershell>
    # Crear usuario local administrador
    $Username = "${local.admin_username}"
    $Password = "${local.admin_password}"
    
    # Crear usuario
    $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    New-LocalUser -Name $Username -Password $SecurePassword -FullName "Local Admin" -Description "Administrador local"
    
    # Agregar al grupo Administradores
    Add-LocalGroupMember -Group "Administrators" -Member $Username
    
    # Configurar RDP
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
    New-NetFirewallRule -DisplayName "Allow RDP" -Profile Any -Action Allow -Protocol TCP -LocalPort 3389
    
    Write-Host "Usuario $Username creado exitosamente"
    </powershell>
  POWERSHELL
}

# Data source para VPC por defecto
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "selected" {
  id = data.aws_subnets.default.ids[0]
}

module "security_group" {
  source = "../../modules/security-group"

  security_group_name = var.security_group_name
  description         = "Security group for Windows EC2 instance - ${var.environment}"
  vpc_id              = data.aws_vpc.default.id
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
  }
}

module "s3_bucket" {
  source = "../../modules/s3-bucket"

  bucket_name        = "${var.bucket_name_prefix}-${var.environment}"
  enable_versioning  = var.enable_bucket_versioning
  enable_encryption  = var.enable_bucket_encryption
  lifecycle_rules    = var.bucket_lifecycle_rules

  tags = {
    Environment = var.environment
  }
}

module "windows_instance" {
  source = "../../modules/windows-instance"

  instance_name       = "${var.project_name}-windows-${var.environment}"
  instance_type       = var.instance_type
  key_name            = var.key_name
  subnet_id           = data.aws_subnets.default.ids[0]
  security_group_id   = module.security_group.security_group_id
  associate_public_ip = true
  associate_eip       = var.associate_eip
  root_volume_config  = var.root_volume_config
  additional_volumes  = var.additional_volumes
  disable_api_termination = var.enable_termination_protection
  monitoring          = var.enable_detailed_monitoring
  
  enable_user_data    = true
  user_data_script    = local.user_data_script

  tags = {
    Environment = var.environment
  }
}