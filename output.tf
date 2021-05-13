output "id" {
  value       = aws_ec2_client_vpn_endpoint.vpn.id
  description = "ID of Client VPN"
}

output "arn" {
  value       = aws_ec2_client_vpn_endpoint.vpn.arn
  description = "ARN of Client VPN"
}

output "endpoint" {
  value       = aws_ec2_client_vpn_endpoint.vpn.dns_name
  description = "Endpoint of Client VPN"
}

output "cw_log_group" {
  value       = var.enable_cw_logging && var.cw_log_group_name == "" ? join(",", aws_cloudwatch_log_group.vpn.*.name) : var.cw_log_group_name
  description = "Name of CloudWatch log group for storing Client VPN connection logs"
}
