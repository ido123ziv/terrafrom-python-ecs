output "alb_dns" {
  value = aws_lb.alb.dns_name
}
output "alb_id" {
  value = aws_lb.alb.id
}
output "target_group_id" {
  value = aws_lb_target_group.alb_tg.id
}
output "listener_id" {
  value = aws_lb_listener.alb_listener.id
}
