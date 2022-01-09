variable "alb_sg" {
  type = string
}
variable "subnets" {
  type = list(string)
}
variable "Application" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "app_port" {
  type = string
}