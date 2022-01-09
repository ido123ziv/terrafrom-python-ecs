variable "Application" {
  type    = string
  default = "awesome-python-app"
}
variable "tags" {
  type = map(string)
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "region" {
  type = string
}
variable "app_port" {
  type = string
}