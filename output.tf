output "id" {
  value = aws_ec2_client_vpn_endpoint.vpn.id
}

output "arn" {
  value = aws_ec2_client_vpn_endpoint.vpn.arn
}

output "endpoint" {
  value = aws_ec2_client_vpn_endpoint.vpn.dns_name
}

output "cw_log_group" {
  value = var.enable_cw_logging && var.cw_log_group_name == "" ? join(",", aws_cloudwatch_log_group.vpn.*.name) : var.cw_log_group_name
}
