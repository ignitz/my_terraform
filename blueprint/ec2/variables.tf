variable "instance_name" { type = string }
variable "instance_type" {
  type    = string
  default = "t3a.micro"
}

variable "vpc_id" { type = string }
variable "key_name" { type = string }
variable "subnet_id" { type = string }
variable "vpc_security_group_ids" {
  type = list(string)
}

variable "user_data" { type = string }
