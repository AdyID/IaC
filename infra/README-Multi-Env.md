# Multi-Environment Management Documentation

## Overview

This document describes how the Infrastructure as Code (IaC) solution supports multiple environments (development and production) with distinct configurations while maintaining a single codebase.

## Objective

Support multiple environments with distinct configurations for:

- **ECS CPU/Memory**: Different resource allocations per environment
- **Desired Task Count**: Scalability differences between environments
- **Environment Variables**: Environment-specific application settings
- **Resource Naming and Tagging**: Clear identification and organization

## Architecture Approach

### Terraform Variable Files Strategy

We use Terraform input variable files (`*.tfvars`) to store environment-specific settings:

- Each environment has its own `.tfvars` file with values that override shared defaults
- Single Terraform codebase manages all environments
- Environment switching is achieved by specifying different variable files

## Naming & Tagging Convention

### Resource Naming

Resource names use variables `${var.name}` and `${var.env}` to ensure uniqueness across environments:

**Examples:**
- ECS Service: `iac-task-phase-tree-development-service`
- ECS Cluster: `iac-task-phase-tree-production-cluster`
- ALB: `iac-task-phase-tree-development-alb`
- Security Group: `iac-task-phase-tree-production-alb-sg`

### Tagging Strategy

All resources inherit tags from `var.tags` for consistent environment tracking:

```hcl
tags = {
  Creator = "adrian"
  Project = "iac-task"
}
```

## Usage Instructions

### Deploying to Development

```bash
# Navigate to infrastructure directory
cd infra

# Initialize Terraform (first time only)
terraform init

# Plan deployment for development
terraform plan -var-file=dev.tfvars

# Apply deployment for development
terraform apply -var-file=dev.tfvars
```

### Deploying to Production

```bash
# Plan deployment for production
terraform plan -var-file=prod.tfvars

# Apply deployment for production
terraform apply -var-file=prod.tfvars
```

### Switching Between Environments

To switch from one environment to another:

1. **Destroy current environment** (if needed):
   ```bash
   terraform destroy -var-file=current-env.tfvars
   ```

2. **Deploy to new environment**:
   ```bash
   terraform apply -var-file=new-env.tfvars
   ```

## Benefits

### Code Reusability
- **Single Codebase**: No need for separate Terraform code for each environment
- **DRY Principle**: Eliminates code duplication across environments
- **Consistency**: Ensures all environments follow the same infrastructure patterns

### Operational Efficiency
- **Quick Environment Switching**: Change environments by specifying different `.tfvars` files
- **Version Control**: All environment configurations tracked in Git
- **Easy Scaling**: Add new environments by creating new `.tfvars` files

### Security & Compliance
- **Clear Separation**: Distinct configurations between development and production
- **Environment Isolation**: Resources are properly isolated and tagged
- **Audit Trail**: All changes tracked through Terraform state and Git history

## Best Practices

### Variable Management
- Use descriptive variable names
- Provide meaningful default values
- Document all variables with descriptions
- Use validation rules where appropriate

### Environment Isolation
- Never share sensitive data between environments
- Use different resource names to prevent conflicts
- Implement proper tagging for cost tracking
- Use separate state files or workspaces if needed

### Deployment Strategy
- Always run `terraform plan` before applying
- Use workspaces or separate state files for production
- Implement proper backup and recovery procedures
- Test changes in development before production

## Troubleshooting

### Common Issues

1. **Variable Conflicts**: Ensure all required variables are defined in `.tfvars` files
2. **Resource Naming**: Check for naming conflicts between environments
3. **State Management**: Verify you're using the correct state file for each environment

### Validation Commands

```bash
# Validate Terraform configuration
terraform validate

# Check variable definitions
terraform plan -var-file=dev.tfvars -detailed-exitcode

# List all resources in current state
terraform state list
```

## Next Steps

- [ ] Create automated deployment pipelines
- [ ] Implement blue-green deployment strategy
- [ ] Add cost optimization recommendations per environment