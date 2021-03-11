# Create an AWS Client VPN

This terraform module will create the following services:
- Client VPN
- CloudWatch Log Group (Optional)
- Security Group (Optional)

## Licence:
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

MIT Licence. See [Licence](LICENCE) for full details.

# Usage Instructions:
## Example:
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

## Variables
| Parameter             | Type    | Description                                                                                                                                                          | Default       | Required |
|-----------------------|---------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|----------|
| name    | string  | Name for Client VPN. Leave it blank for a random name           |    | N   |
| vpn_cidr_block    | string  | CIDR block to use for Client VPN. **Note:** This should not overlap with VPC CIDR block           | 192.168.0.0/16    | N   |
| server_cert_arn    | string  | Server certificate ARN stored in AWS ACM           |     | Y   |
| subnet_ids    | list  | Subnet IDs to associate with Client VPN           |     | Y   |
| security_group_ids    | list  | Security group ID to associate with Client VPN. Leave it blank to auto-create one           |     | N   |
| dns_servers    | list  | Custom DNS servers to associate with Client VPN. Leave it blank to pick VPCs default DNS server           |     | N   |
| enable_split_tunnel    | boolean  | Disable it to use Client VPN for both internal and internet traffic           | true    | N   |
| transport_protocol    | string  | Supports `udp` or `tcp` protocol          | udp    | N   |
| auth_type    | string  | Type of client authentication to use. Supported values: `certificate-authentication`, `directory-service-authentication` and `federated-authentication`           | certificate-authentication    | N   |
| root_cert_arn    | string  | The ARN of the client certificate. The certificate must be signed by a certificate authority (CA) and it must be provisioned in AWS Certificate Manager (ACM). **Note:** Required ONLY for certificate-authentication type           |     | N   |
| ad_id    | string  | The ID of the Active Directory to be used for authentication. **Note:** Required ONLY for directory-service-authentication type           |     | N   |
| saml_arn    | string  | The ARN of the IAM SAML identity provider. **Note:** Required ONLY for federated-authentication type           |     | N   |
| enable_cw_logging    | boolean  | Whether to log VPN connections to CloudWatch           | true    | N   |
| cw_log_group_name    | string  | Name for CloudWatch Log group           |     | N   |
| authorize_all_groups    | boolean  | Indicates whether the authorization rule grants access to all clients. **Note:** One of `access_group_id` or `authorize_all_groups` must be set.  | true    | N   |
| access_group_id    | string  | The ID of the group to which the authorization rule grants access. **Note:** One of `access_group_id` or `authorize_all_groups` must be set.           |     | N   |
| tags    | map    | Map of key value pair to assign to certificate             |     | N    |

## Outputs
| Parameter           | Type   | Description               |
|---------------------|--------|---------------------------|
| id     | string | ID of Client VPN            |
| arn     | string | ARN of Client VPN            |
| endpoint    | string | Endpoint of Client VPN            |
| cw_log_group    | string | Name of CloudWatch log group for storing Client VPN connection logs            |

## Deployment
- `terraform init` - download plugins required to deploy resources
- `terraform plan` - get detailed view of resources that will be created, deleted or replaced
- `terraform apply -auto-approve` - deploy the template without confirmation (non-interactive mode)
- `terraform destroy -auto-approve` - terminate all the resources created using this template without confirmation (non-interactive mode)
