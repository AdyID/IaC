variable "name" {
  type        = string
  description = "Name prefix for network resources"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to network resources"
}
