# PhaseTree IaC Project

Infrastructure as Code (IaC) solution for deploying a containerized FastAPI application across development and production environments using Terraform and GitHub Actions.

## Architecture Overview

This project implements a modern cloud-native architecture with:

- **Containerized Application**: FastAPI web service with science-themed content
- **AWS Infrastructure**: ECR, ECS, IAM, CloudWatch, and networking components
- **Multi-Environment Support**: Separate dev and prod configurations
- **CI/CD Pipeline**: Automated deployment with GitHub Actions
- **Security**: tfsec scanning and least-privilege IAM policies

## Project Structure

```
IaC/
├── app/                   # FastAPI application code
├── infra/                 # Terraform infrastructure code
│   ├── modules/          # Reusable Terraform modules
│   ├── dev.tfvars        # Development environment config
│   └── prod.tfvars       # Production environment config
├── .github/workflows/    # CI/CD pipelines
├── Dockerfile            # Container configuration
└── requirements.txt      # Python dependencies
```

## Quick Start

### Prerequisites
- AWS CLI configured
- Terraform installed
- Docker installed
- GitHub repository with secrets configured
- Python 3.12 installed

### Local Development
```bash
# Run the application locally
docker-compose up

# Access the application
curl http://localhost:8000/health
```

### Infrastructure Deployment
```bash
# Deploy to development
cd infra
terraform init
terraform apply -var-file=dev.tfvars

# Deploy to production
terraform apply -var-file=prod.tfvars
```

## Environments

| Environment | CPU | Memory | Tasks | Purpose |
|-------------|-----|--------|-------|---------|
| **Development** | 0.25 vCPU | 512 MB | 1 | Testing and development |
| **Production** | 0.5 vCPU | 1024 MB | 3 | Live application |

## CI/CD Pipeline

- **Development**: Automatic deployment on code push
- **Production**: Manual approval with explicit image tag
- **Security**: Automated tfsec scanning
- **Caching**: Docker layer caching for faster builds

## API Endpoints

- `GET /health` - Health check
- `GET /version` - Application version
- `GET /` - Welcome message
- `GET /pun` - Science puns
- `GET /fact` - Science facts

## Configuration

Environment-specific configurations are managed through:
- `dev.tfvars` - Development environment variables
- `prod.tfvars` - Production environment variables
- Environment variables passed to containers via Terraform

## Security Features

- tfsec security scanning in CI/CD
- Least-privilege IAM policies
- Private ECR repositories
- Environment protection rules

## Monitoring

- CloudWatch log groups with proper naming
- Application logs with configurable log levels
- Health check endpoints for monitoring

## Known Limitations

- ECS task/service deployment requires iam:PassRole and ecs:RegisterTaskDefinition permissions
- ALB creation blocked due to VPC quota reached
- AWS Secret Key creation blocked due to permissions