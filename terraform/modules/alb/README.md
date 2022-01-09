# ALB Module

This module creates ALB for the ECS application including:
* Application Load Balancer
* HTTP Listener
* IP Target Group 

## Input Variables
* *alb_sg* -> Security Group for Application Load Balancer
* *subnets* -> [list] of public subnets ids to deploy ALB in
* *region* -> AWS Region to work on
* *app_port* -> Port that the python app listens to.
* *Application* -> Name of your ecs app
* *vpc_cidr* -> CIDR for your VPC

## Ouptus 
* alb_dns -> DNS Name of the Application Load Balancers
* alb_id -> ID of the Application Load Balancers
* target_group_id -> Target Group Id for ECS
* listener_id -> Listener of Load Balancer ID
