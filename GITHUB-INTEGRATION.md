# GitHub Integration Guide

## Overview: Where GitHub Connects

```
Your Code (Local) 
    ↓ (git push)
GitHub Repository
    ↓ (webhook/poll)
Jenkins Pipeline (Jenkinsfile)
    ↓ (builds)
Docker Images
    ↓ (pushes to)
Container Registry (ECR)
    ↓ (pulls from)
Kubernetes Cluster
```

## 1. Setup GitHub Repository

### Your GitHub Repository:
```bash
Repository: https://github.com/RashmikaHarshamal/Kubernetes-deployement.git
Status: ✓ Already created and pushed
```

### Push updates to GitHub:
```bash
# After making changes
cd "E:/Projects/Kubernetes Deployement"

# Add changes
git add .

# Commit
git commit -m "Your commit message"

# Push to GitHub
git push origin main

# Push to GitHub
git branch -M main
git push -u origin main
```

## 2. Jenkins Configuration

### A. Install Required Jenkins Plugins:
- Git Plugin
- GitHub Plugin
- GitHub Branch Source Plugin
- Pipeline Plugin

### B. Configure Jenkins Job:

**Method 1: Pipeline from SCM (Recommended)**
```
1. Jenkins Dashboard → New Item
2. Enter name: "user-management-pipeline"
3. Select "Pipeline" → OK
4. In Pipeline section:
   - Definition: "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: https://github.com/RashmikaHarshamal/Kubernetes-deployement.git
   - Credentials: Add your GitHub credentials
   - Branch: */main
   - Script Path: Jenkinsfile
5. Save
```

**Method 2: GitHub Webhook (Auto-trigger on push)**
```
1. In Jenkins job → Configure → Build Triggers
2. Check "GitHub hook trigger for GITScm polling"
3. Save

4. In GitHub Repository:
   - Settings → Webhooks → Add webhook
   - Payload URL: http://YOUR-JENKINS-URL/github-webhook/
   - Content type: application/json
   - Events: Just the push event
   - Active: ✓
   - Add webhook
```

## 3. Update Jenkinsfile with Your Settings

Edit your Jenkinsfile (lines 5-6):
```groovy
environment {
    // Your ECR registry
    DOCKER_REGISTRY = '804329959270.dkr.ecr.ap-south-1.amazonaws.com'
    DOCKER_CREDENTIALS_ID = 'aws-ecr-credentials'
    
    // Image names
    BACKEND_IMAGE = "${DOCKER_REGISTRY}/backend"
    FRONTEND_IMAGE = "${DOCKER_REGISTRY}/frontend"
}
```

## 4. Kubernetes Deployment Configuration

Your Kubernetes YAML files already point to your registry:
```yaml
# backend-deployment.yaml (line 19)
image: 804329959270.dkr.ecr.ap-south-1.amazonaws.com/backend:latest

# frontend-deployment.yaml (line 19)
image: 804329959270.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest
```

## 5. Complete Workflow

### Development Workflow:
```bash
# 1. Make changes to your code
cd "E:/Projects/Kubernetes Deployement"
vim Frontend/app.js  # or any file

# 2. Test locally
docker-compose up -d

# 3. Commit and push to GitHub
git add .
git commit -m "Updated user interface"
git push origin main

# 4. Jenkins automatically (if webhook configured):
#    - Detects the push
#    - Runs Jenkinsfile pipeline
#    - Builds Docker images
#    - Pushes to ECR
#    - Deploys to Kubernetes
```

### Manual Jenkins Trigger:
```
1. Go to Jenkins Dashboard
2. Click on your pipeline job
3. Click "Build Now"
```

## 6. GitHub Repository Structure

Your repository should look like:
```
Kubernetes-deployement/
├── .gitignore
├── README.md
├── DEPLOYMENT-GUIDE.md
├── docker-compose.yml
├── Jenkinsfile
├── Backend/
│   ├── .dockerignore
│   ├── .gitignore
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/
├── Frontend/
│   ├── .dockerignore
│   ├── .gitignore
│   ├── Dockerfile
│   ├── package.json
│   ├── app.js
│   ├── index.html
│   └── style.css
├── backend-deployment.yaml
├── backend-service.yaml
├── frontend-deployment.yaml
├── frontend-service.yaml
├── mysql-deployment.yaml
├── mysql-service.yaml
├── mysql-secret.yaml
├── ingress.yaml
└── deploy-all.sh
```

## 7. Connection Points Summary

| Component | GitHub Connection | Configuration File |
|-----------|------------------|-------------------|
| **Jenkins** | Pulls code from GitHub | Jenkinsfile + Jenkins Job Config |
| **Docker Build** | Uses code from Jenkins checkout | Dockerfile (Frontend & Backend) |
| **Container Registry** | Receives images from Jenkins | Jenkinsfile (environment vars) |
| **Kubernetes** | Pulls images from ECR | *-deployment.yaml files |

## 8. Secret Management

### Store these in Jenkins Credentials:
```
1. GitHub Credentials
   - ID: github-credentials
   - Type: Username with password
   - Username: your-github-username
   - Password: your-github-personal-access-token

2. AWS/ECR Credentials
   - ID: aws-ecr-credentials
   - Type: AWS Credentials
   - Access Key ID: your-aws-access-key
   - Secret Access Key: your-aws-secret-key
```

## 9. Testing the Integration

```bash
# 1. Push code to GitHub
git push origin main

# 2. Check Jenkins build
# Go to: http://your-jenkins-url/job/user-management-pipeline/

# 3. Verify Docker images in ECR
aws ecr describe-images --repository-name backend --region ap-south-1
aws ecr describe-images --repository-name frontend --region ap-south-1

# 4. Check Kubernetes deployment
kubectl get pods
kubectl get ingress
```

## 10. Troubleshooting

### Jenkins can't access GitHub:
```
- Check GitHub credentials in Jenkins
- Verify repository URL is correct
- Check firewall/network settings
```

### Build fails at Docker push:
```
- Verify AWS credentials in Jenkins
- Check ECR repository exists
- Ensure IAM permissions for ECR
```

### Kubernetes doesn't pull new images:
```
- Check imagePullPolicy: Always in deployment YAML
- Verify ECR access from Kubernetes cluster
- Check image tags match
```

---

## Quick Setup Commands

```bash
# Push updates to GitHub
git add .
git commit -m "Update description"
git push origin main

# Create ECR repositories
aws ecr create-repository --repository-name backend --region ap-south-1
aws ecr create-repository --repository-name frontend --region ap-south-1

# Configure Jenkins job (via UI)
# Then trigger build
```
