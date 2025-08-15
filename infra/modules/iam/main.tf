# Execution Role for ECS Tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-${var.env}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17" # Identity-based policies version (IAM users, roles, groups)
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "ecs_task_execution_policy" {
  name = "${var.name}-${var.env}-execution-policy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17" # Identity-based policies version (IAM users, roles, groups)
    Statement = [
      # ECR: pull images
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = var.ecr_repository_arn
      },
      # CloudWatch Logs: write logs to this group
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${var.log_group_arn}:*"
      }
    ]
  })
}

# Task Role for the containerized app
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-${var.env}-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

# Attempt to see if permission was due to creation before tag permissions were added
resource "aws_iam_role" "ecs_task_execution_role_v2" {
  name = "${var.name}-${var.env}-execution-role${var.suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "ecs_task_execution_policy_v2" {
  name = "${var.name}-${var.env}-execution-policy${var.suffix}"
  role = aws_iam_role.ecs_task_execution_role_v2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = var.ecr_repository_arn
      },
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${var.log_group_arn}:*"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_role_v2" {
  name = "${var.name}-${var.env}-task-role${var.suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}