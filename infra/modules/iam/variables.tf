variable "name" {
  type        = string
  description = "Name prefix for IAM roles and policies"
}

variable "env" {
  type        = string
  description = "Environment name (e.g., development, staging, production)"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all IAM resources"
}

variable "ecr_repository_arn" {
  type        = string
  description = "ARN of the ECR repository for image pull permissions"
}

variable "log_group_arn" {
  type        = string
  description = "ARN of the CloudWatch log group for log write permissions"
}
