output "log_group_name" {
  value       = aws_cloudwatch_log_group.ecs_app.name
  description = "Name of the CloudWatch log group"
}

output "log_group_arn" {
  value       = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.ecs_app.name}"
  description = "ARN of the CloudWatch log group"
}