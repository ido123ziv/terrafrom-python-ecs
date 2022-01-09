# Terraform
In this folder we are creating all the AWS Resources.

## Prerequisites
* `terraform init`
* run `aws configure` to configure the default aws profile
* start Docker
* run `../aws-cli/create_bucket_for_terraform.sh` to create the bucket.

## Important files:
* `providers.tf` -> determines the plugins, aws profile and terraform version
* `variables.tf` -> declares the variables for the root module
* `terraform.tfvars` -> assign the values 
* `output.tf` -> outputs of the terraform root module

## Order of commamds
1. write code
2. `terraform plan`
3. `terraform apply`

## Why to use child-models?
We use sub-models for code that can be reused, for example it is highly likely that we will create more ECS services so We can call the module to create another service, IaC Classic!

## Structure of Models
├── README.md
├── ecs.tf
├── iam.tf
├── main.tf
├── modules
│   ├── alb
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── ecs
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── output.tf
├── providers.tf
├── terraform.tfvars
├── upload_image.sh
└── variables.tf

## Input Variables
* *Application* -> Name of your ecs app
* *tags* -> Tags to apply on your AWS Resources
* *vpc_cidr* -> CIDR for your VPC
* *region* -> AWS Region to work on
* *app_port* -> Port that the python app listens to.

## Ouptus 
* *application-url* -> DNS Name of Load Balancer
* *repo_url* -> ECR Repo URL.

## Files Content Basics
* `ecs.tf` created ecr repo and ecs cluster
* `iam.tf` created IAM Roles for task execution and task roles.