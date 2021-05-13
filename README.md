# Create an AWS managed Client VPN

![License](https://img.shields.io/github/license/terrablocks/aws-client-vpn?style=for-the-badge) ![Tests](https://img.shields.io/github/workflow/status/terrablocks/aws-client-vpn/tests/master?label=Test&style=for-the-badge) ![Checkov](https://img.shields.io/github/workflow/status/terrablocks/aws-client-vpn/checkov/master?label=Checkov&style=for-the-badge) ![Commit](https://img.shields.io/github/last-commit/terrablocks/aws-client-vpn?style=for-the-badge) ![Release](https://img.shields.io/github/v/release/terrablocks/aws-client-vpn?style=for-the-badge)

This terraform module will deploy the following services:
- Client VPN
- CloudWatch Log Group (Optional)
- Security Group (Optional)

# Usage Instructions
## Example
### Certificate Authentication
```terraform
module "client_vpn" {
  source = "github.com/terrablocks/aws-client-vpn.git"

  server_cert_arn = "arn:aws:acm:ap-south-1:xxxxxxxxxx:certificate/xxxxx-xxxx-xxxx-xxxx-xxxxxxx"
  subnet_ids      = ["subnet-xxx", "subnet-xxx"]
  root_cert_arn   = "arn:aws:acm:ap-south-1:xxxxxxxxxx:certificate/xxxxx-xxxx-xxxx-xxxx-xxxxxxx"
}
```
### AD Authentication
```terraform
module "client_vpn" {
  source = "github.com/terrablocks/aws-client-vpn.git"

  server_cert_arn = "arn:aws:acm:ap-south-1:xxxxxxxxxx:certificate/xxxxx-xxxx-xxxx-xxxx-xxxxxxx"
  subnet_ids      = ["subnet-xxx", "subnet-xxx"]
  auth_type       = "directory-service-authentication"
  ad_id           = ""
}
```
### SAML Authentication
```terraform
module "client_vpn" {
  source = "github.com/terrablocks/aws-client-vpn.git"

  server_cert_arn = "arn:aws:acm:ap-south-1:xxxxxxxxxx:certificate/xxxxx-xxxx-xxxx-xxxx-xxxxxxx"
  subnet_ids      = ["subnet-xxx", "subnet-xxx"]
  auth_type       = "federated-authentication"
  saml_arn        = ""
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.37.0 |
| random | 3.1.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name for Client VPN. Ignore it for assigning a random name | `string` | `null` | no |
| vpn_cidr_block | CIDR block to use for Client VPN. **Note:** This should not overlap with VPC CIDR block | `string` | `"192.168.0.0/16"` | no |
| server_cert_arn | Server certificate ARN stored in AWS ACM | `string` | n/a | yes |
| subnet_ids | Subnet IDs to associate with Client VPN | `list(string)` | n/a | yes |
| security_group_ids | Security group ID to associate with Client VPN. Leave it blank to auto-create one | `list(string)` | `[]` | no |
| dns_servers | Custom DNS servers to associate with Client VPN. Leave it blank to pick VPCs default DNS server | `list(string)` | `null` | no |
| enable_split_tunnel | Disable it to use Client VPN for both internal and internet traffic | `bool` | `true` | no |
| transport_protocol | Supports `udp` or `tcp` protocol | `string` | `"udp"` | no |
| auth_type | Type of client authentication to use. Supported values: `certificate-authentication`, `directory-service-authentication` and `federated-authentication` | `string` | `"certificate-authentication"` | no |
| root_cert_arn | The ARN of the client certificate. The certificate must be signed by a certificate authority (CA) and it must be provisioned in AWS Certificate Manager (ACM). **Note:** Required ONLY for certificate-authentication type | `string` | `null` | no |
| ad_id | The ID of the Active Directory to be used for authentication. **Note:** Required ONLY for directory-service-authentication type | `string` | `null` | no |
| saml_arn | The ARN of the IAM SAML identity provider. **Note:** Required ONLY for federated-authentication type | `string` | `null` | no |
| enable_cw_logging | Whether to log VPN connection information to CloudWatch | `bool` | `true` | no |
| cw_log_group_name | Name for CloudWatch Log group to store VPN connection details | `string` | `null` | no |
| logs_kms_key | Alias/ARN/Id of KMS key to be used for rest-side encryption | `string` | `null` | no |
| logs_retention_days | Specifies the number of days you want to retain VPN logs. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0 where 0 will retain logs for infinite period | `number` | `0` | no |
| authorize_all_groups | Indicates whether the authorization rule grants access to all clients. **Note:** One of `access_group_id` or `authorize_all_groups` must be set | `bool` | `true` | no |
| access_group_id | The ID of the group to which the authorization rule grants access. **Note:** One of `access_group_id` or `authorize_all_groups` must be set | `string` | `null` | no |
| tags | Map of key value pair to assign to Client VPN | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of Client VPN |
| arn | ARN of Client VPN |
| endpoint | Endpoint of Client VPN |
| cw_log_group | Name of CloudWatch log group for storing Client VPN connection logs |
