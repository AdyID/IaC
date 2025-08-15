output "log_group_name" {
  value       = aws_cloudwatch_log_group.ecs_app.name
  description = "Name of the CloudWatch log group"
}

output "log_group_arn" {
  value       = aws_cloudwatch_log_group.ecs_app.arn
  description = "ARN of the CloudWatch log group"
}