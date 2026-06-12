resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = var.security_group_name
  })
}

# RDP Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "rdp_ipv4" {
  count = var.allow_rdp && length(var.allowed_rdp_cidr_blocks) > 0 ? length(var.allowed_rdp_cidr_blocks) : 0

  security_group_id = aws_security_group.this.id

  cidr_ipv4   = var.allowed_rdp_cidr_blocks[count.index]
  from_port   = var.rdp_config.from_port
  ip_protocol = var.rdp_config.protocol
  to_port     = var.rdp_config.to_port

  description = "${var.rdp_config.description} from ${var.allowed_rdp_cidr_blocks[count.index]}"
}

resource "aws_vpc_security_group_ingress_rule" "rdp_ipv6" {
  count = var.allow_rdp && length(var.allowed_rdp_ipv6_cidr_blocks) > 0 ? length(var.allowed_rdp_ipv6_cidr_blocks) : 0

  security_group_id = aws_security_group.this.id

  cidr_ipv6   = var.allowed_rdp_ipv6_cidr_blocks[count.index]
  from_port   = var.rdp_config.from_port
  ip_protocol = var.rdp_config.protocol
  to_port     = var.rdp_config.to_port

  description = "${var.rdp_config.description} from ${var.allowed_rdp_ipv6_cidr_blocks[count.index]}"
}

# Additional Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "additional" {
  count = length(var.ingress_rules)

  security_group_id = aws_security_group.this.id

  cidr_ipv4   = try(var.ingress_rules[count.index].cidr_blocks[0], null)
  cidr_ipv6   = try(var.ingress_rules[count.index].ipv6_cidr_blocks[0], null)
  from_port   = var.ingress_rules[count.index].from_port
  ip_protocol = var.ingress_rules[count.index].protocol
  to_port     = var.ingress_rules[count.index].to_port

  description = var.ingress_rules[count.index].description
}

# Egress Rules
resource "aws_vpc_security_group_egress_rule" "custom" {
  count = length(var.egress_rules)

  security_group_id = aws_security_group.this.id

  cidr_ipv4   = try(var.egress_rules[count.index].cidr_blocks[0], null)
  cidr_ipv6   = try(var.egress_rules[count.index].ipv6_cidr_blocks[0], null)
  from_port   = var.egress_rules[count.index].from_port
  ip_protocol = var.egress_rules[count.index].protocol
  to_port     = var.egress_rules[count.index].to_port

  description = var.egress_rules[count.index].description
}