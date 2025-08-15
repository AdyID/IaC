# --- Data ---
# Commented out due to permission issues
# data "aws_secretsmanager_secret" "dummy" {
#   name = "/${var.name}/${var.env}/dummy_secret"
# }

# data "aws_secretsmanager_secret_version" "dummy" {
#   secret_id = data.aws_secretsmanager_secret.dummy.id
# }

# --- ECS ---
resource "aws_ecs_cluster" "this" {
  name = "${var.name}-${var.env}-cluster"
  tags = var.tags
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name}-${var.env}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.name
      image     = "${var.ecr_repository_url}:${var.image_tag}"
      essential = true
      environment = [
        { name = "LOG_LEVEL", value = var.log_level },
        { name = "GREETING_MESSAGE", value = var.greeting_message },
        { name = "APP_VERSION", value = var.app_version }
      ]
      # Commented secrets out due to permission issues
      # secrets = [
      #   {
      #     name      = "DUMMY_SECRET"
      #     valueFrom = data.aws_secretsmanager_secret_version.dummy.arn
      #   }
      # ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.region
          awslogs-stream-prefix = var.name
        }
      }
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = var.tags
}

resource "aws_ecs_service" "this" {
  name            = "${var.name}-${var.env}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  # Networking and ALB not available due to VPC limit
  # network_configuration {
  #   subnets         = var.private_subnet_ids
  #   security_groups = [var.ecs_service_sg_id]
  #   assign_public_ip = false
  # }

  # load_balancer {
  #   target_group_arn = var.target_group_arn
  #   container_name   = var.name
  #   container_port   = 80
  # }

  tags = var.tags
}
