# ECR Outputs
output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "URL of the ECR repository"
}

output "ecr_repository_arn" {
  value       = module.ecr.repository_arn
  description = "ARN of the ECR repository"
}

# CloudWatch Logs Outputs
output "log_group_name" {
  value       = module.logs.log_group_name
  description = "Name of the CloudWatch log group"
}

output "log_group_arn" {
  value       = module.logs.log_group_arn
  description = "ARN of the CloudWatch log group"
}

# # ALB Outputs
# output "alb_dns_name" {
#   value       = module.alb.alb_dns_name
#   description = "DNS name of the Application Load Balancer"
# }
