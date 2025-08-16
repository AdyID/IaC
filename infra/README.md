# Infrastructure as Code (Terraform)

Infrastructure as Code solution for deploying a containerized FastAPI application on AWS using Terraform modules and GitHub Actions CI/CD.

## Architecture Summary

### Technology Stack
- **Infrastructure**: Terraform 1.12.2
- **Container Orchestration**: AWS ECS Fargate
- **Container Registry**: AWS ECR
- **Logging**: AWS CloudWatch Logs
- **Security**: AWS IAM with least-privilege policies

### Infrastructure Components

```
AWS Infrastructure
├── ECR Repository          # Container image storage
├── ECS Cluster            # Container orchestration
├── ECS Service            # Application deployment
├── ECS Task Definition    # Container configuration
├── IAM Roles              # Execution and task roles
├── CloudWatch Log Groups  # Application logging
└── (Commented) ALB        # Load balancer (VPC limit)
```

### Design Choices

1. **Modular Architecture**: Reusable Terraform modules for each AWS service
2. **Environment Isolation**: Separate configurations for dev and prod
3. **Least Privilege**: IAM roles with minimal required permissions
4. **Centralized Logging**: CloudWatch log groups with proper naming
5. **Security First**: Non-root containers, IAM policies
6. **Scalability**: Fargate for serverless container management

## Project Structure

```
infra/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
├── outputs.tf              # Output values
├── dev.tfvars              # Development environment variables
├── prod.tfvars             # Production environment variables
└── modules/
    ├── ecr/                # ECR repository module
    ├── ecs/                # ECS cluster and service module
    ├── iam/                # IAM roles and policies module
    ├── logs/               # CloudWatch logs module
    ├── alb/                # Application Load Balancer module
    └── network/            # VPC and networking module
```

## Setup Instructions

### Prerequisites
- Terraform 1.12.2 or higher
- AWS CLI configured with appropriate credentials
- Docker (for building and pushing images)
- GitHub repository with secrets configured

### AWS Configuration
```bash
# Configure AWS credentials
aws configure
```

### Local Development Setup

1. **Initialize Terraform**
   ```bash
   cd infra/
   terraform init
   ```

2. **Plan Deployment**
   ```bash
   # Development
   terraform plan -var-file=dev.tfvars
   
   # Production
   terraform plan -var-file=prod.tfvars
   ```

3. **Apply Infrastructure**
   ```bash
   # Development
   terraform apply -var-file=dev.tfvars
   
   # Production
   terraform apply -var-file=prod.tfvars
   ```

## Build Instructions

### Manual Infrastructure Deployment
```bash
# Development environment
terraform apply -var-file=dev.tfvars -var="image_tag=latest"

# Production environment
terraform apply -var-file=prod.tfvars -var="image_tag=1.0.0"
```

### Import Existing Resources
The GitHub Actions workflows automatically import existing resources:

```bash
# ECR Repository
terraform import -var-file=dev.tfvars module.ecr.aws_ecr_repository.this iac-task-development

# CloudWatch Log Group
terraform import -var-file=dev.tfvars module.logs.aws_cloudwatch_log_group.ecs_app adrian-applogs/development/iac-phase-tree

# IAM Roles
terraform import -var-file=dev.tfvars module.iam.aws_iam_role.ecs_task_execution_role iac-phase-tree-development-execution-role
terraform import -var-file=dev.tfvars module.iam.aws_iam_role.ecs_task_role iac-phase-tree-development-task-role
```

## Deployment Instructions

### Environment Configurations

#### Development Environment (`dev.tfvars`)
```hcl
region      = "eu-central-1"
aws_profile = "iac-task"
name        = "iac-phase-tree"
ecr_name    = "iac-task"
image_tag   = "latest"

task_cpu      = 256
task_memory   = 512
desired_count = 1

log_level        = "INFO"
greeting_message = "Welcome to the PhaseTree code challenge interview development!"
app_version      = "1.0.0"
env              = "development"
```

#### Production Environment (`prod.tfvars`)
```hcl
region      = "eu-central-1"
aws_profile = "iac-task"
name        = "iac-task-phase-tree"
ecr_name    = "iac-task"
image_tag   = "1.0.0"  # Set manually at deploy time

task_cpu      = 512
task_memory   = 1024
desired_count = 3

log_level        = "INFO"
greeting_message = "Welcome to the PhaseTree code challenge interview production!"
app_version      = "1.0.0"
env              = "production"
```

### Automated Deployment via GitHub Actions

1. **Development**: Automatic deployment on push to `dev` branch
2. **Production**: Manual deployment with explicit image tag

### Environment Variables Reference

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `region` | string | Yes | AWS region for resource deployment |
| `aws_profile` | string | Yes | AWS profile name |
| `name` | string | Yes | Application name prefix |
| `ecr_name` | string | Yes | ECR repository name |
| `image_tag` | string | Yes | Docker image tag to deploy |
| `task_cpu` | number | Yes | ECS task CPU units (256, 512, 1024, ...) |
| `task_memory` | number | Yes | ECS task memory in MiB |
| `desired_count` | number | Yes | Number of ECS service instances |
| `log_level` | string | Yes | Application log level |
| `greeting_message` | string | Yes | Application greeting message |
| `app_version` | string | Yes | Application version |
| `env` | string | Yes | Environment name |
| `tags` | map | Yes | Resource tags |

## Access Instructions

### Infrastructure Outputs
```bash
# Get ECR repository URL
terraform output -raw ecr_repository_url

# Get CloudWatch log group name
terraform output -raw log_group_name

# Get all outputs
terraform output
```

### Application Access
- **ECS Service**: Access via ECS console or AWS CLI
- **CloudWatch Logs**: View application logs in CloudWatch console
- **ECR Repository**: Push/pull images via Docker

### Monitoring Resources
```bash
# View CloudWatch logs
aws logs describe-log-streams --log-group-name adrian-applogs/development/iac-phase-tree

# Check ECR repository
aws ecr describe-repositories --repository-names iac-task-development
```

## Cleanup Instructions

*Note: Careful with destroying as it might mess up the state due to permissions*

### Destroy Infrastructure
```bash
# Development environment
terraform destroy -var-file=dev.tfvars

# Production environment
terraform destroy -var-file=prod.tfvars
```

## Assumptions and Dependencies

### Infrastructure Assumptions
1. **AWS Account**: Valid AWS account with appropriate permissions
2. **VPC Limits**: VPC quota reached (ALB module commented out)
3. **IAM Permissions**: Limited to create/manage own resources only
4. **Resource Naming**: Consistent naming convention across environments
5. **Log Retention**: 14-day log retention for cost optimization

### AWS Service Dependencies
- **ECS**: Container orchestration and management
- **ECR**: Container image storage and distribution
- **IAM**: Identity and access management
- **CloudWatch**: Logging and monitoring
- **Fargate**: Serverless compute for containers

### External Dependencies
- **Terraform**: Infrastructure provisioning tool
- **Docker**: Container image building and management
- **GitHub Actions**: CI/CD pipeline automation
- **AWS CLI**: AWS resource management

### Security Considerations
- **Least Privilege**: IAM roles with minimal required permissions
- **Resource Isolation**: Environment-specific resource naming
- **Log Security**: CloudWatch logs with proper retention
- **Container Security**: Non-root user execution
- **Network Security**: Security groups (when ALB is enabled)

## Module Details

### ECR Module (`modules/ecr/`)
- **Purpose**: Container image repository
- **Features**: Mutable image tags, proper tagging
- **Outputs**: Repository URL, ARN, name

### ECS Module (`modules/ecs/`)
- **Purpose**: Container orchestration
- **Features**: Fargate tasks, environment variables, logging
- **Outputs**: Cluster ID, task definition ARN

### IAM Module (`modules/iam/`)
- **Purpose**: Identity and access management
- **Features**: Execution and task roles, least-privilege policies
- **Outputs**: Role ARNs for ECS integration

### Logs Module (`modules/logs/`)
- **Purpose**: Centralized logging
- **Features**: CloudWatch log groups, proper naming convention
- **Outputs**: Log group name and ARN

### ALB Module (`modules/alb/`) - Commented
- **Purpose**: Load balancing (currently disabled due to VPC limits)
- **Features**: Application Load Balancer, target groups, security groups
- **Status**: Ready for use when VPC quota allows

### Network Module (`modules/network/`) - Commented
- **Purpose**: Creates and manages VPC and subnets for ECS workloads
- **Features**: Provides VPC and subnet resources with outputs for integration.
- **Status**: Currently commented out due to AWS VPC quota limits; ready for use when limits are increased.

## Troubleshooting

### Debug Commands
```bash
# Validate Terraform configuration
terraform validate

# Check Terraform plan
terraform plan -var-file=dev.tfvars -detailed-exitcode

# View Terraform state
terraform show

# Check AWS resource status
aws ecs describe-services --cluster $(terraform output -raw ecs_cluster_id)
```

### Log Analysis
```bash
# View CloudWatch logs
aws logs tail adrian-applogs/development/iac-phase-tree --follow

# Check ECS task logs
aws logs describe-log-streams --log-group-name adrian-applogs/development/iac-phase-tree
```

## Security Features

### IAM Security
- **Execution Role**: Minimal permissions for ECR pull and CloudWatch logs
- **Task Role**: Application-specific permissions (currently minimal)
- **Least Privilege**: Only required permissions granted

### Network Security
- **Security Groups**: Proper ingress/egress rules (when ALB enabled)
- **Private Subnets**: ECS tasks in private subnets (when VPC available)
- **Load Balancer**: Public access through ALB (when enabled)

### Container Security
- **Non-root User**: Containers run as non-root
- **Image Scanning**: ECR image scanning capabilities
- **Resource Limits**: CPU and memory limits enforced

## Cost Optimization

### Resource Sizing
- **Development**: 0.25 vCPU, 512 MB RAM, 1 instance
- **Production**: 0.5 vCPU, 1024 MB RAM, 3 instances

### Log Management
- **Retention**: 14-day log retention
- **Log Groups**: Environment-specific naming
- **Cost Monitoring**: CloudWatch cost insights

### Infrastructure Efficiency
- **Fargate**: Pay-per-use container compute
- **Auto Scaling**: ECS service auto-scaling capabilities
- **Resource Tagging**: Proper tagging for cost allocation
