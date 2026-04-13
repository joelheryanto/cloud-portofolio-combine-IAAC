# Docker - Containerized Flask App

## What I Built
A Python Flask app containerized with Docker and pushed to AWS ECR.

## Architecture
app.py (Flask) -> Dockerfile -> Docker Image -> AWS ECR (Container Registry)

## Files
| File | Description |
|---|---|
| app.py | Flask application |
| Dockerfile | Container instructions |
| requirements.txt | Python dependencies |

## Key Commands
`bash
# Build image
docker build -t simple-app .

# Run container
docker run -p 5000:5000 simple-app

# Push to ECR
docker push <ecr-url>/simple-app:latest

# What I Learned
Containerization concepts  
Dockerfile best practices  
AWS ECR for image registry  