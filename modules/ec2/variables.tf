# variable "region" { type = string }
# variable "default_name" { type = string }
# variable "environment" { type = string }
# variable "key_pair" { type = string }
# variable "cidr_blocks" { type = list(string) }
# variable "subnet_ids" { type = map(string) }

# variable "payload_kinesis" { type = string }

variable "instance_name" { type = string }
variable "vpc_id" { type = string }
variable "key_name" { type = string }
variable "subnet_id" { type = string }
variable "codeserver_password" { type = string }
variable "portainer_username" {
  type    = string
  default = "admin"
}
variable "portainer_password" { type = string }
variable "jupyter_password" { type = string }
