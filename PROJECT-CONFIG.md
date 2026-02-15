# Project Configuration - Quick Reference

## GitHub Repository
- **URL**: https://github.com/RashmikaHarshamal/Kubernetes-deployement.git
- **Owner**: RashmikaHarshamal
- **Status**: ✓ Active and pushed

## Docker Registry (AWS ECR)
- **Registry**: 804329959270.dkr.ecr.ap-south-1.amazonaws.com
- **Region**: ap-south-1 (Mumbai)
- **Backend Image**: 804329959270.dkr.ecr.ap-south-1.amazonaws.com/backend
- **Frontend Image**: 804329959270.dkr.ecr.ap-south-1.amazonaws.com/frontend

## Jenkins Configuration
- **Pipeline Type**: Pipeline from SCM
- **SCM**: Git
- **Repository URL**: https://github.com/RashmikaHarshamal/Kubernetes-deployement.git
- **Branch**: */main
- **Script Path**: Jenkinsfile

## Application Endpoints

### Local Development:
- Frontend: http://localhost:3000
- Backend: http://localhost:8080
- Backend API: http://localhost:8080/api/v3

### Docker Compose:
- Frontend: http://localhost
- Backend: http://localhost:8080
- MySQL: localhost:3306

### Kubernetes:
- Get ingress address: `kubectl get ingress app-ingress`
- Frontend: http://<INGRESS-ADDRESS>/
- Backend API: http://<INGRESS-ADDRESS>/api/v3

## Quick Commands

### Git Commands:
```bash
# Push changes
git add .
git commit -m "Your message"
git push origin main

# Pull latest
git pull origin main

# Check status
git status
```

### Docker Commands:
```bash
# Build images
docker build -t 804329959270.dkr.ecr.ap-south-1.amazonaws.com/backend:latest ./Backend
docker build -t 804329959270.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest ./Frontend

# Login to ECR
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 804329959270.dkr.ecr.ap-south-1.amazonaws.com

# Push images
docker push 804329959270.dkr.ecr.ap-south-1.amazonaws.com/backend:latest
docker push 804329959270.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest

# Run with docker-compose
docker-compose up -d
docker-compose down
```

### Kubernetes Commands:
```bash
# Deploy everything
bash deploy-all.sh

# Check status
kubectl get all
kubectl get ingress
kubectl get pods

# View logs
kubectl logs -l app=backend
kubectl logs -l app=frontend

# Delete all
kubectl delete -f backend-deployment.yaml
kubectl delete -f frontend-deployment.yaml
kubectl delete -f mysql-deployment.yaml
```

## Jenkins Credentials Needed

### 1. GitHub Credentials
- **ID**: github-credentials
- **Type**: Username with password
- **Username**: RashmikaHarshamal
- **Password**: [Personal Access Token from GitHub]
- **Generate Token**: https://github.com/settings/tokens

### 2. AWS ECR Credentials
- **ID**: aws-ecr-credentials
- **Type**: AWS Credentials
- **Access Key ID**: [Your AWS Access Key]
- **Secret Access Key**: [Your AWS Secret Key]

## Database Configuration

### MySQL Credentials (from mysql-secret.yaml):
- **Root Password**: rootpassword
- **Database**: userdb
- **Username**: userapp
- **Password**: userpassword

**⚠️ IMPORTANT**: Change these credentials for production!

## Backend API Endpoints

Base URL: `/api/v3`

- **GET** `/getusers` - Get all users
- **GET** `/getuser/{id}` - Get user by ID
- **POST** `/adduser` - Create new user
- **PUT** `/updateuser` - Update user
- **DELETE** `/deleteuser/{id}` - Delete user

## File Structure Reference

```
Kubernetes-deployement/
├── Backend/                    # Spring Boot application
├── Frontend/                   # JavaScript UI
├── backend-deployment.yaml     # Kubernetes deployment for backend
├── backend-service.yaml        # Kubernetes service for backend
├── frontend-deployment.yaml    # Kubernetes deployment for frontend
├── frontend-service.yaml       # Kubernetes service for frontend
├── mysql-deployment.yaml       # MySQL database deployment
├── mysql-service.yaml          # MySQL service
├── mysql-secret.yaml          # Database credentials
├── ingress.yaml               # Ingress configuration (AWS ALB)
├── ingress-nginx.yaml         # Ingress configuration (Nginx)
├── docker-compose.yml         # Docker Compose configuration
├── Jenkinsfile               # CI/CD pipeline
├── deploy-all.sh             # Automated deployment script
├── setup-ingress.sh          # Ingress controller setup
├── check-ingress.sh          # Check ingress status
└── README.md                 # Project documentation
```

## Support & Documentation

- **Main README**: [README.md](README.md)
- **Deployment Guide**: [DEPLOYMENT-GUIDE.md](DEPLOYMENT-GUIDE.md)
- **GitHub Integration**: [GITHUB-INTEGRATION.md](GITHUB-INTEGRATION.md)
- **Useful Commands**: [k8s-commands.sh](k8s-commands.sh)

---

**Last Updated**: February 15, 2026
**Repository**: https://github.com/RashmikaHarshamal/Kubernetes-deployement.git
