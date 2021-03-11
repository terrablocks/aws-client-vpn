variable "name" {
  default = ""
}

variable "vpn_cidr_block" {
  default = "192.168.0.0/16"
}

variable "server_cert_arn" {
  default = ""
}

variable "subnet_ids" {
  type    = list(any)
  default = []
}

variable "security_group_ids" {
  type = list
  default = []
}

variable "dns_servers" {
  type    = list(any)
  default = null
}

variable "enable_split_tunnel" {
  default = true
}

variable "transport_protocol" {
  default = "udp"
}

variable "auth_type" {
  default = "certificate-authentication"
}

variable "root_cert_arn" {
  default = null
}

variable "ad_id" {
  default = null
}

variable "saml_arn" {
  default = null
}

variable "enable_cw_logging" {
  default = true
}

variable "cw_log_group_name" {
  default = null
}

variable "authorize_all_groups" {
  default = true
}

variable "access_group_id" {
  default = null
}

variable "tags" {
  type    = map(any)
  default = {}
}
