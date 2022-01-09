resource "aws_cloudwatch_log_group" "application-logs" {
  name = "${var.Application}-LogGroup"
}
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.Application
  execution_role_arn       = var.task_exec_role
  task_role_arn            = var.task_role
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  # Fargate cpu/mem must match available options: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  cpu    = var.fargate_cpu
  memory = var.fargate_mem
  container_definitions = jsonencode(
    [
      {
        name      = "${var.Application}"
        image     = "${var.ecr_url}:${var.image_tag}"
        cpu       = "${var.fargate_cpu}"
        memory    = "${var.fargate_mem}"
        essential = true
        portMappings = [
          {
            containerPort = 5000
            hostPort      = 5000
        }]
        logConfiguration : {
          logDriver : "awslogs",
          options : {
            awslogs-group : "${var.Application}-LogGroup",
            awslogs-region : "${var.region}",
            awslogs-stream-prefix : "${var.Application}"
          }
        }
      }
    ]
  )
  tags = {
    Name = "${var.Application}"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name             = "${var.Application}-srv"
  cluster          = var.cluster_id
  task_definition  = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count    = var.autoscale_scale_down
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.ecs_sg]
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.Application
    container_port   = var.app_port
  }
  # Ignored desired count changes live, permitting schedulers to update this value without terraform reverting
  lifecycle {
    ignore_changes = [desired_count]
  }
  depends_on = [aws_ecs_task_definition.ecs_task_definition]
}

resource "aws_appautoscaling_target" "ServiceAutoScalingTarget" {
  min_capacity       = var.autoscale_scale_down
  max_capacity       = var.autoscale_scale_up
  resource_id        = "service/${var.cluster_id}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  lifecycle {
    ignore_changes = [
      min_capacity,
      max_capacity,
    ]
  }
  depends_on = [aws_ecs_task_definition.ecs_task_definition]

}
