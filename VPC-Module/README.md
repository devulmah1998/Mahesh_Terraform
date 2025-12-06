# AWS VPC Terraform Module

This module creates a complete AWS VPC with public and private subnets, Internet Gateway, and optional NAT Gateway.

## Features

- VPC with custom CIDR block
- Public subnets with Internet Gateway
- Private subnets with NAT Gateway (optional)
- DNS support enabled
- Configurable availability zones
- Tagging support

## Usage

```bash
# Initialize Terraform
terraform init

# Plan the infrastructure
terraform plan

# Apply the configuration
terraform apply

# Destroy the infrastructure
terraform destroy
```

## Module Structure

```
VPC-Module/
├── modules/
│   └── vpc/
│       ├── main.tf       # VPC resources
│       ├── variables.tf  # Module variables
│       └── outputs.tf    # Module outputs
├── main.tf              # Root module
├── variables.tf         # Root variables
├── outputs.tf           # Root outputs
├── provider.tf          # Provider configuration
└── terraform.tfvars     # Variable values
```

## Customize

Edit `terraform.tfvars` to customize your VPC configuration:
- Change region, CIDR blocks, availability zones
- Enable/disable NAT Gateway
- Update tags and naming
