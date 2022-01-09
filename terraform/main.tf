module "vpc" {
  source      = "./modules/vpc"
  Application = var.Application
  vpc_cidr    = var.vpc_cidr
  region      = var.region
  app_port    = var.app_port
}

module "alb" {
  source      = "./modules/alb"
  alb_sg      = module.vpc.alb_sg
  subnets     = module.vpc.public_subnets
  Application = var.Application
  vpc_id      = module.vpc.vpc_id
  app_port    = var.app_port
}

module "ecs" {
  source           = "./modules/ecs"
  ecs_sg           = module.vpc.ecs_sg
  subnets          = module.vpc.private_subnets
  cluster_id       = aws_ecs_cluster.ecs_cluster.id
  target_group_arn = module.alb.target_group_id
  Application      = var.Application
  vpc_id           = module.vpc.vpc_id
  app_port         = var.app_port
  task_exec_role   = aws_iam_role.ecs_task_execution_role.arn
  task_role        = aws_iam_role.ecs_task_role.arn
  ecr_url          = aws_ecr_repository.ecr_repo.repository_url
  region           = var.region

}

