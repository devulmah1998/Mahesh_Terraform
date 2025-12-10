# Terraform Workspaces Example

This example demonstrates using Terraform workspaces to manage multiple environments (dev, staging, prod) with different configurations.

## What are Workspaces?

Workspaces allow you to manage multiple instances of the same infrastructure with separate state files. Each workspace has its own state, allowing you to deploy the same configuration to different environments.

## Usage

### 1. Initialize Terraform
```bash
terraform init
```

### 2. List Workspaces
```bash
terraform workspace list
```

### 3. Create and Switch to Dev Workspace
```bash
terraform workspace new dev
# or switch to existing
terraform workspace select dev
```

### 4. Deploy to Dev (1 t2.micro instance)
```bash
terraform plan
terraform apply
```

### 5. Create and Deploy to Staging
```bash
terraform workspace new staging
terraform apply
# Creates 2 t2.small instances
```

### 6. Create and Deploy to Prod
```bash
terraform workspace new prod
terraform apply
# Creates 3 t2.medium instances
```

### 7. Switch Between Workspaces
```bash
terraform workspace select dev
terraform workspace select staging
terraform workspace select prod
```

### 8. Show Current Workspace
```bash
terraform workspace show
```

### 9. Delete a Workspace
```bash
# First switch to another workspace
terraform workspace select default
# Destroy resources in the workspace you want to delete
terraform workspace select dev
terraform destroy
# Switch back and delete
terraform workspace select default
terraform workspace delete dev
```

## Key Features

- **Workspace-specific naming**: Resources are named with workspace prefix (e.g., `dev-instance-1`)
- **Different instance counts**: Dev=1, Staging=2, Prod=3
- **Different instance types**: Dev=t2.micro, Staging=t2.small, Prod=t2.medium
- **Separate state files**: Each workspace maintains its own state
- **Environment tagging**: All resources tagged with workspace name

## Workspace Interpolation

The `terraform.workspace` variable is used throughout:
- Resource naming: `${terraform.workspace}-instance`
- Conditional logic: `lookup(var.instance_count, terraform.workspace, 1)`
- Tags: `Environment = terraform.workspace`

## State Files Location

State files are stored in:
- Default workspace: `terraform.tfstate`
- Named workspaces: `terraform.tfstate.d/<workspace-name>/terraform.tfstate`
