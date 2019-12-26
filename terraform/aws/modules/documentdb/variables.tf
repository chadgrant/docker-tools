variable "instance_count" {
  default = 3
}
variable "instance_size" {
  default = "db.r4.large"
}

variable "username"               {}
variable "password"               {}
variable "subnet_ids"             {}
variable "security_group_ids"     {}
variable "availabilty_zones"      {}
variable "aws_region"             {}
variable "environment_short_name" {}
variable "environment"            {}
variable "team"                   {}
variable "application"            {}