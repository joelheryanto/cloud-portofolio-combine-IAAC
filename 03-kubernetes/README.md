# Kubernetes - Container Orchestration

## What I Built
Deployed containerized Flask app to Kubernetes with self-healing demonstration.

## Architecture
Docker Image
↓
Kubernetes Deployment (2 replicas)
↓
Kubernetes Service (NodePort)
↓
App accessible via localhost
## Files
| File | Description |
|---|---|
| deployment.yaml | Pod deployment config |
| service.yaml | Service exposure config |

## Key Commands
`bash
# Deploy app
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Check pods
kubectl get pods

# Check service
kubectl get service

# Access app
minikube service simple-app-service

# Delete pod (self-healing demo)
kubectl delete pod <pod-name>
What I Learned
Kubernetes core concepts (Pod, Deployment, Service)
Self-healing capabilities
Local K8s with Minikube
YAML configuration