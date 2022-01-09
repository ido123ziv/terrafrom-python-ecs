variable "ecs_sg" {
  type = string
}
variable "subnets" {
  type = list(string)
}
variable "cluster_id" {
  type = string
}
variable "target_group_arn" {
  type = string
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
variable "task_exec_role" {
  type = string
}
variable "task_role" {
  type = string
}
variable "fargate_cpu" {
  type    = number
  default = 1024
}
variable "fargate_mem" {
  type    = number
  default = 2048
}
variable "image_tag" {
  type    = string
  default = "latest"
}
variable "ecr_url" {
  type = string
}
variable "autoscale_scale_up" {
  type    = number
  default = 5
}
variable "autoscale_scale_down" {
  type    = number
  default = 1
}
variable "region" {
  type = string
}