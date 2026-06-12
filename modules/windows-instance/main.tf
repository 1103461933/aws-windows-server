data "aws_ami" "windows" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.windows.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip
  disable_api_termination     = var.disable_api_termination
  monitoring                  = var.monitoring

  user_data = var.enable_user_data ? var.user_data_script : null

  credit_specification {
    cpu_credits = var.credit_specification.cpu_credits
  }

  metadata_options {
    http_endpoint               = var.metadata_options.http_endpoint
    http_tokens                 = var.metadata_options.http_tokens
    http_put_response_hop_limit = var.metadata_options.http_put_response_hop_limit
  }

  root_block_device {
    volume_type = var.root_volume_config.type
    volume_size = var.root_volume_config.size
    encrypted   = var.root_volume_config.encrypted
    iops        = var.root_volume_config.type == "io1" || var.root_volume_config.type == "io2" ? var.root_volume_config.iops : null
    throughput  = var.root_volume_config.type == "gp3" ? var.root_volume_config.throughput : null

    tags = merge(var.tags, {
      Name = "${var.instance_name}-root"
    })
  }

  dynamic "ebs_block_device" {
    for_each = var.additional_volumes
    content {
      device_name = ebs_block_device.value.device_name
      volume_type = ebs_block_device.value.volume_type
      volume_size = ebs_block_device.value.volume_size
      encrypted   = ebs_block_device.value.encrypted
      iops        = ebs_block_device.value.volume_type == "io1" || ebs_block_device.value.volume_type == "io2" ? ebs_block_device.value.iops : null
      throughput  = ebs_block_device.value.volume_type == "gp3" ? ebs_block_device.value.throughput : null

      tags = merge(var.tags, {
        Name = "${var.instance_name}-${ebs_block_device.value.device_name}"
      })
    }
  }

  tags = merge(var.tags, {
    Name = var.instance_name
  })
}

resource "aws_eip" "this" {
  count = var.associate_eip ? 1 : 0

  instance = aws_instance.this.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.instance_name}-eip"
  })
}