region      = "eu-central-1"
aws_profile = "iac-task"

name     = "iac-task-phase-tree"
ecr_name = "iac-task"

log_group_prefix   = "adrian-applogs"
log_retention_days = 14

task_cpu      = 256
task_memory   = 512
desired_count = 1

image_tag        = "v1"
log_level        = "INFO"
greeting_message = "Welcome to the PhaseTree code challenge interview development!"
app_version      = "1.0.0"
env              = "development"

tags = {
  Creator = "adrian"
  Project = "iac-task"
}