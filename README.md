# terraform-python-ecs
In this repo I'm creating a sample python app using flask, terraform script to deploy the app in the cloud.
Using my Dockerfile and `aws-cli` scripts to create the remaining resources.

## Structure
├── README.md
├── aws-cli
│   ├── README.md
│   ├── create_bucket_for_terraform.sh
│   └── upload_image.sh
├── docker
│   ├── Dockerfile
│   ├── README.md
│   └── build.sh
├── python-sample-api
│   ├── Dockerfile
│   ├── LICENSE
│   ├── README.md
│   ├── app.py
│   ├── build.sh
│   └── requirements.txt
└── terraform
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

## Prerequisites
* install terraform
* install `aws-cli`
* install Docker
* run `aws configure` to configure the default aws profile

## How to run?
1. First run `aws-cli/create_bucket_for_terraform.sh` to create the bucket for terraform
2. `cd python-sample-api`
3. `./build.sh`
4. `cd ../terraform`
5. `terraform init`
6. `terraform plan`
7. `terraform apply`

## Notes
In each folder I've put the scripts I used for this project, all actions were made by these scripts, nothing with the console.
In `aws-cli` and `docker` you'll find copies for scripts used in other folders.