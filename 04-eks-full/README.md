 EKS Full Pipeline - Production Deployment

## What I Built
Full production-grade deployment pipeline using Terraform to provision EKS cluster and deploy containerized app accessible from the internet.

## Architecture
|Terraform|
|↓|
|AWS VPC + Subnets + IGW|
|↓|
|EKS Cluster (joel-eks)|
|↓|
|Node Group (t3.small)
|↓|
|Docker Image (ECR)|
|↓|
|Kubernetes Deployment|
|↓|
|LoadBalancer Service|
|↓|
| Live on Internet!|

## Files
| File | Description |
|---|---|
| main.tf | EKS + VPC Terraform code |
| deployment.yaml | K8s deployment config |
| service.yaml | K8s LoadBalancer service |

## Key Commands
`bash
# Provision infrastructure
terraform init
terraform apply

# Connect kubectl to EKS
aws eks update-kubeconfig --name joel-eks --region ap-southeast-1

# Deploy app
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Get public URL
kubectl get service

# Destroy everything
kubectl delete service simple-app-service
terraform destroy
What I Learned
EKS cluster provisioning with Terraform
Connecting kubectl to AWS EKS
LoadBalancer service for public access
Full Docker → ECR → EKS pipeline
Clean infrastructure teardown