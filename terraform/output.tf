output "application-url" {
  value = module.alb.alb_dns
}
output "repo_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}