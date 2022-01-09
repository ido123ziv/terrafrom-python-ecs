# VPC Module

This module creates VPC for the ECS application including:
* VPC
* 3 public subnets
* 3 private subnets
* Internet Gateway
* Private & Public Route Tables
* NAT Gateway
* S3 VPC Endpoint
* ECR, Logs EndPoint
* Security Groups for:
* * VPC Endpoints
* * Application Load Balancers
* * ECS Services

## Input Variables
* *Application* -> Name of your ecs app
* *vpc_cidr* -> CIDR for your VPC
* *region* -> AWS Region to work on
* *app_port* -> Port that the python app listens to.

## Ouptus 
* vpc_id -> ID of the VPC Created
* ecs_sg -> Security Group for ECS Service (access from ALB)
* alb_sg -> Security Group for Application Load Balancer (access from world)
* private_subnets -> [list] of private subnets ids
* public_subnets -> [list] of public subnets ids
