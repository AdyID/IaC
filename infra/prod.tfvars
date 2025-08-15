region      = "eu-central-1"
aws_profile = "iac-task"

name     = "iac-task-phase-tree"
ecr_name = "iac-task"

# Set manually at deploy time
image_tag = "1.0.0"

log_group_prefix   = "adrian-applogs"
log_retention_days = 14

task_cpu      = 512
task_memory   = 1024
desired_count = 3

log_level        = "INFO"
greeting_message = "Welcome to the PhaseTree code challenge interview production!"
app_version      = "1.0.0"
env              = "production"

tags = {
  Creator = "adrian"
  Project = "iac-task"
}

