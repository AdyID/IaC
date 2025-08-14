variable "name" {
  type        = string
  description = "Name for the application (used in log group name)"
}

variable "env" {
  type        = string
  description = "Environment name (dev or prod) to isolate log groups"
}

variable "region" {
  type        = string
  description = "AWS region where resources will be created"
}

variable "log_group_prefix" {
  type        = string
  description = "Prefix for the CloudWatch log group name"
}

variable "retention_in_days" {
  type        = number
  description = "Number of days to retain log events"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the log group"
}
