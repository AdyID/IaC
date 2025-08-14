data "aws_caller_identity" "current" {} # Necessary to compile the ARN of the log group since we don't have Describe permissions

resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "${var.log_group_prefix}/${var.env}/${var.name}"
  retention_in_days = var.retention_in_days
  tags              = var.tags
}
