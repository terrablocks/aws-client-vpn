resource "random_pet" "vpn" {}

locals {
  vpn_name = var.name == null ? random_pet.vpn.id : var.name
}

data "aws_kms_key" "vpn" {
  key_id = var.logs_kms_key
}

resource "aws_cloudwatch_log_group" "vpn" {
  count             = var.enable_cw_logging && var.cw_log_group_name == "" ? 1 : 0
  name              = "${local.vpn_name}-client-vpn-logs"
  kms_key_id        = data.aws_kms_key.vpn.arn
  retention_in_days = var.logs_retention_days
  tags              = var.tags
}

resource "aws_ec2_client_vpn_endpoint" "vpn" {
  client_cidr_block      = var.vpn_cidr_block
  server_certificate_arn = var.server_cert_arn
  description            = "${local.vpn_name} Client VPN"

  authentication_options {
    type                       = var.auth_type
    root_certificate_chain_arn = var.root_cert_arn
    active_directory_id        = var.ad_id
    saml_provider_arn          = var.saml_arn
  }

  connection_log_options {
    enabled              = var.enable_cw_logging
    cloudwatch_log_group = var.cw_log_group_name == "" ? join(",", aws_cloudwatch_log_group.vpn.*.name) : var.cw_log_group_name
  }

  dns_servers        = var.dns_servers
  split_tunnel       = var.enable_split_tunnel
  transport_protocol = var.transport_protocol

  tags = merge(
    {
      Name = local.vpn_name
    }, var.tags
  )

  lifecycle {
    ignore_changes = [
      connection_log_options["cloudwatch_log_stream"]
    ]
  }
}

resource "aws_security_group" "vpn" {
  # checkov:skip=CKV2_AWS_5: Assocaited to Client VPN if user does not provide custom security group
  count       = length(var.security_group_ids) == 0 ? 1 : 0
  name        = "${local.vpn_name}-vpn-sg"
  description = "Security group for ${local.vpn_name} client vpn"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn" {
  count                  = length(var.subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = var.subnet_ids[count.index]
  security_groups        = length(var.security_group_ids) == 0 ? aws_security_group.vpn.*.id : var.security_group_ids
}

data "aws_subnet" "vpn" {
  count = length(var.subnet_ids)
  id    = var.subnet_ids[count.index]
}

data "aws_vpc" "vpn" {
  id = data.aws_subnet.vpn[0].vpc_id
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn" {
  count                  = length(data.aws_vpc.vpn.cidr_block_associations)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = data.aws_vpc.vpn.cidr_block_associations[count.index].cidr_block
  authorize_all_groups   = var.authorize_all_groups
  access_group_id        = var.access_group_id
}
