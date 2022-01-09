resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.Application}-repo"
  image_tag_mutability = "MUTABLE"
  tags                 = var.tags
  provisioner "local-exec" {
    command = "${path.root}/upload_image.sh ${var.Application}-repo"
  }
}
resource "aws_cloudwatch_log_group" "ecs_exec_logs" {
  name = "${var.Application}-execute-command-logs"
  tags = var.tags
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.Application}-cluster"
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_exec_logs.name
      }
    }
  }
  tags = var.tags
}
