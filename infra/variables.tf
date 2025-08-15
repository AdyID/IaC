variable "region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "name" {
  type = string
}

variable "ecr_name" {
  type = string
}

variable "log_group_prefix" {
  type = string
}

variable "log_retention_days" {
  type = number
}

variable "task_cpu" {
  type = number
}

variable "task_memory" {
  type = number
}

variable "desired_count" {
  type = number
}

variable "image_tag" {
  type = string
}

variable "log_level" {
  type = string
}

variable "greeting_message" {
  type = string
}

variable "app_version" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "suffix" {
  type = string
}