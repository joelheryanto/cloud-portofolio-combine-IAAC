# Architecture Diagram

## Full CI/CD Pipeline
```mermaid
flowchart TD
    A[👨‍💻 Developer Laptop] -->|git push| B[GitHub Repository]
    B -->|trigger| C[GitHub Actions]
    C -->|build| D[Docker Image]
    D -->|push| E[AWS ECR]
    E -->|deploy| F[AWS EKS Cluster]
    
    subgraph AWS Cloud ap-southeast-1
        subgraph VPC
            subgraph EKS Cluster
                F --> G[Node Group]
                G --> H[Pod: simple-app]
            end
        end
        E
        I[Load Balancer] --> H
    end
    
    I -->|public url| J[🌐 Internet]
```

## AWS Services Used

| Service | Purpose |
|---|---|
| EKS | Kubernetes cluster |
| ECR | Container registry |
| VPC | Network isolation |
| Subnet | Network segmentation |
| IGW | Internet access |
| ALB | Load balancing |
| IAM | Access management |

## CI/CD Flow

| Step | Tool | Action |
|---|---|---|
| 1 | Git | Push code |
| 2 | GitHub Actions | Trigger pipeline |
| 3 | Docker | Build image |
| 4 | ECR | Store image |
| 5 | kubectl | Deploy to EKS |
| 6 | EKS | Run containers |

## Tech Stack

| Category | Technology |
|---|---|
| Language | Python (Flask) |
| Container | Docker |
| Orchestration | Kubernetes (EKS) |
| IaC | Terraform |
| CI/CD | GitHub Actions |
| Cloud | AWS |