variable "ecr_name" {
  type        = string
  description = "Name of the ECR repository"
}

variable "env" {
  type        = string
  description = "Environment name (dev or prod) to isolate log groups"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the ECR repository"
}
