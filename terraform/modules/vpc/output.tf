output "vpc_id" {
  value = aws_vpc.main.id
}
output "ecs_sg" {
  value = aws_security_group.ecs_sg.id
}
output "alb_sg" {
  value = aws_security_group.alb_sg.id
}
output "private_subnets" {
  value = aws_subnet.private.*.id
}
output "public_subnets" {
  value = aws_subnet.public.*.id
}