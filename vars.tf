variable "name" {
  type        = string
  default     = null
  description = "Name for Client VPN. Ignore it for assigning a random name"
}

variable "vpn_cidr_block" {
  type        = string
  default     = "192.168.0.0/16"
  description = "CIDR block to use for Client VPN. **Note:** This should not overlap with VPC CIDR block"
}

variable "server_cert_arn" {
  type        = string
  description = "Server certificate ARN stored in AWS ACM"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs to associate with Client VPN"
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Security group ID to associate with Client VPN. Leave it blank to auto-create one"
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "Custom DNS servers to associate with Client VPN. Leave it blank to pick VPCs default DNS server"
}

variable "enable_split_tunnel" {
  type        = bool
  default     = true
  description = "Disable it to use Client VPN for both internal and internet traffic"
}

variable "transport_protocol" {
  type        = string
  default     = "udp"
  description = "Supports `udp` or `tcp` protocol"
}

variable "auth_type" {
  type        = string
  default     = "certificate-authentication"
  description = "Type of client authentication to use. Supported values: `certificate-authentication`, `directory-service-authentication` and `federated-authentication`"
}

variable "root_cert_arn" {
  type        = string
  default     = null
  description = "The ARN of the client certificate. The certificate must be signed by a certificate authority (CA) and it must be provisioned in AWS Certificate Manager (ACM). **Note:** Required ONLY for certificate-authentication type"
}

variable "ad_id" {
  type        = string
  default     = null
  description = "The ID of the Active Directory to be used for authentication. **Note:** Required ONLY for directory-service-authentication type"
}

variable "saml_arn" {
  type        = string
  default     = null
  description = "The ARN of the IAM SAML identity provider. **Note:** Required ONLY for federated-authentication type"
}

variable "enable_cw_logging" {
  type        = bool
  default     = true
  description = "Whether to log VPN connection information to CloudWatch"
}

variable "cw_log_group_name" {
  type        = string
  default     = null
  description = "Name for CloudWatch Log group to store VPN connection details"
}

variable "logs_kms_key" {
  type        = string
  default     = null
  description = "Alias/ARN/Id of KMS key to be used for rest-side encryption"
}

variable "logs_retention_days" {
  type        = number
  default     = 0
  description = "Specifies the number of days you want to retain VPN logs. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0 where 0 will retain logs for infinite period"
}

variable "authorize_all_groups" {
  type        = bool
  default     = true
  description = "Indicates whether the authorization rule grants access to all clients. **Note:** One of `access_group_id` or `authorize_all_groups` must be set"
}

variable "access_group_id" {
  type        = string
  default     = null
  description = "The ID of the group to which the authorization rule grants access. **Note:** One of `access_group_id` or `authorize_all_groups` must be set"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of key value pair to assign to Client VPN"
}
