# GitHub Actions Deployment Guide

This guide explains how to deploy the application using the automated GitHub Actions workflows.

## Overview

The project includes two deployment workflows:

- **Development Deployment** (`deploy-dev.yml`) - Automatic deployment on push to `dev` branch
- **Production Deployment** (`deploy-prod.yml`) - Manual deployment with approval

## Prerequisites

Before deploying, ensure you have:

1. **AWS Credentials** configured as GitHub Secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

2. **GitHub Environment** set up for production (optional but recommended)

## Development Deployment

### Automatic Deployment
Development deployments happen automatically when you push code to the `dev` branch:

```bash
git checkout dev
git add .
git commit -m "Your changes"
git push origin dev
```

### What Happens
1.  Code checkout
2.  Security scan with tfsec
3.  Terraform infrastructure deployment
4.  Docker image build and push to ECR
5.  Application deployment to ECS

### Environment Details
- **Region**: eu-central-1
- **Resources**: 0.25 vCPU, 512 MB RAM
- **Tasks**: 1 running instance
- **Image Tag**: `latest`

## Production Deployment

### Manual Deployment
Production deployments require manual approval and explicit image tag:

1. Go to **Actions** tab in GitHub
2. Select **"Deploy to Production"** workflow
3. Click **"Run workflow"**
4. Enter the image tag (e.g., `1.0.0`, `v2.1.0`)
5. Click **"Run workflow"**

### What Happens
1.  Image tag validation
2.  Security scan with tfsec
3.  Terraform infrastructure deployment
4.  Docker image build and push to ECR
5.  Application deployment to ECS

### Environment Details
- **Region**: eu-central-1
- **Resources**: 0.5 vCPU, 1024 MB RAM
- **Tasks**: 3 running instances
- **Image Tag**: User-specified (e.g., `1.0.0`)

## Deployment Status

### Check Deployment Status
1. Go to **Actions** tab in GitHub
2. Click on the workflow run
3. Monitor the steps in real-time

### Common Issues

#### Terraform Import Errors
The workflows attempt to import existing resources. These errors are normal if resources don't exist yet:
```
ECR repository already in state or doesn't exist
Log group already in state or doesn't exist
```

#### Security Scan Warnings
tfsec runs with `soft_fail: true` to prevent workflow failures. Check the scan results in the workflow output.

### Development
Simply push a new commit to the `dev` branch to deploy the previous version.

### Production
1. Go to **Actions** tab
2. Run the production workflow with the previous image tag
3. Or manually update the ECS service in AWS Console

## Security Features

- **tfsec Scanning**: Automated security analysis of Terraform code
- **Environment Protection**: Production deployments require approval
- **Image Tagging**: Traceable deployments with commit hashes
- **Least Privilege**: IAM roles with minimal required permissions

## Troubleshooting

### Workflow Fails
1. Check the workflow logs for specific error messages
2. Verify AWS credentials are correctly configured
3. Ensure the target branch exists (`dev` for development)

### Terraform Errors
1. Check if resources already exist in AWS
2. Verify variable files (`dev.tfvars`, `prod.tfvars`) are correct
3. Ensure AWS region and credentials are properly configured