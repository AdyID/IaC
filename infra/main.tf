# --- ECR ---
module "ecr" {
  source = "./modules/ecr"

  ecr_name = var.ecr_name
  env      = var.env
  tags     = var.tags
}

# # --- Network ---
# module "vpc" {
#   source = "./modules/network"

#   name = var.name
#   env  = var.env
#   tags = var.tags
# }

# --- CloudWatch Logs ---
module "logs" {
  source = "./modules/logs"

  name              = var.name
  env               = var.env
  log_group_prefix  = var.log_group_prefix
  retention_in_days = var.log_retention_days
  region            = var.region
  tags              = var.tags
}

# --- IAM ---
module "iam" {
  source = "./modules/iam"

  name               = var.name
  env                = var.env
  suffix             = var.suffix
  tags               = var.tags
  ecr_repository_arn = module.ecr.repository_arn
  log_group_arn      = module.logs.log_group_arn

  depends_on = [
    module.ecr,
    module.logs
  ]
}

# # --- ALB ---
# module "alb" {
#   source            = "./modules/alb"
#   name              = var.name
#   env               = var.env
#   vpc_id            = module.vpc.vpc_id
#   public_subnet_ids = module.vpc.public_subnet_ids
#   tags              = var.tags
# }

# --- ECS ---
module "ecs" {
  source = "./modules/ecs"

  name             = var.name
  env              = var.env
  task_cpu         = var.task_cpu
  task_memory      = var.task_memory
  image_tag        = var.image_tag
  log_level        = var.log_level
  greeting_message = var.greeting_message
  app_version      = var.app_version
  region           = var.region
  tags             = var.tags

  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn
  ecr_repository_url = module.ecr.repository_url
  log_group_name     = module.logs.log_group_name

  desired_count       = var.desired_count
  # private_subnet_ids  = module.vpc.private_subnet_ids
  # ecs_service_sg_id   = module.alb.ecs_service_sg_id
  # target_group_arn    = module.alb.target_group_arn
  # alb_listener_arn    = module.alb.listener_arn
}