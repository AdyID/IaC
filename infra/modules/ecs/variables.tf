variable "name" {
  type        = string
  description = "Name of the ECS service and related resources"
}

variable "env" {
  type        = string
  description = "Environment name (e.g., development, staging, production)"
}

variable "task_cpu" {
  type        = number
  description = "CPU units for the ECS task (256, 512, 1024, 2048, ...)"
}

variable "task_memory" {
  type        = number
  description = "Memory for the ECS task in MiB (512, 1024, 2048, ...)"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag to deploy"
}

variable "log_level" {
  type        = string
  description = "Application log level (DEBUG, INFO, WARN, ERROR)"
}

variable "greeting_message" {
  type        = string
  description = "Custom greeting message for the application"
}

variable "app_version" {
  type        = string
  description = "Application version identifier"
}

variable "region" {
  type        = string
  description = "AWS region where resources will be created"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all ECS resources"
}

variable "execution_role_arn" {
  type        = string
  description = "IAM role ARN that ECS uses to pull images from ECR and write logs to CloudWatch"
}

variable "task_role_arn" {
  type        = string
  description = "IAM role ARN that the containerized app uses to access AWS resources"
}

variable "ecr_repository_url" {
  type        = string
  description = "URL of the ECR repository"
}

variable "log_group_name" {
  type        = string
  description = "Name of the CloudWatch log group"
}

variable "desired_count" {
  type        = number
  description = "Desired number of ECS service instances"
}

variable "target_group_arn" {
  description = "ARN of the ALB Target Group"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for ECS tasks"
}

variable "ecs_service_sg_id" {
  description = "Security Group ID for ECS service"
}

variable "alb_listener_arn" {
  description = "Listener ARN to depend on for ordering"
}