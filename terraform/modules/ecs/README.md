# ECS Module

This module creates ECS service for the application including:
* ECS Task Definiton
* Log Group for ECS
* ECS Service
* ECS AutoScaler

## Input Variables
* *ecs_sg* -> Security Group for Application Load Balancer
* *subnets* -> [list] of private subnets ids to deploy ALB in
* *region* -> AWS Region to work on
* *app_port* -> Port that the python app listens to.
* *Application* -> Name of your ecs app
* *vpc_cidr* -> CIDR for your VPC
* *target_group_arn* -> Target Group for ECS
* *cluster_id* -> Cluster to deploy in
* task_exec_role -> IAM Role for basic task execution
* task_role -> IAM Role to grant the task access to AWS Services such as ECR or S3
* fargate_cpu -> CPU requirements for the task
* fargate_mem -> Memory requirements for the task
* image_tag -> Image tag for application (for example: latest)
* ecr_url -> ECR Repository URL
* autoscale_scale_up -> minimum tasks desired
* autoscale_scale_down -> maximum tasks desired


## Ouptus 
* ecs_service -> ID of the ECS Service


