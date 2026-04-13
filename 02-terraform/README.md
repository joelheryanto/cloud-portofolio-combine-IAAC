# Terraform - Infrastructure as Code

## What I Built
AWS infrastructure provisioned using Terraform - VPC, Subnets, Security Groups, and EC2.

## Architecture
Terraform Code -> AWS VPC (10.0.0.0/16) -> Subnets + Internet Gateway -> Security Group -> EC2 Instance

## Files
| File | Description |
|---|---|
| main.tf | Main infrastructure code |

## Key Commands
`bash
# Initialize
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply

# Destroy infrastructure
terraform destroy

# What I Learned
Infrastructure as Code concepts  
Terraform providers and resources  
AWS networking (VPC, Subnets, IGW)  
State management with tfstate  