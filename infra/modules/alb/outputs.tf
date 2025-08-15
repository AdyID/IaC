output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "listener_arn" {
  value = aws_lb_listener.this.arn
}

output "ecs_service_sg_id" {
  value = aws_security_group.ecs_service_sg.id
}
