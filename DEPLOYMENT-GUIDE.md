# User Management System - Deployment Guide

This guide shows how to deploy YOUR existing User Management application.

## What You Already Have

✅ **Frontend**: HTML/CSS/JavaScript User Management UI  
✅ **Backend**: Spring Boot REST API with User CRUD operations  
✅ **Database**: MySQL (configured in deployments)

## Deployment Options

### Option 1: Local Development (Current)

Run directly on your machine:

```bash
# Terminal 1 - Start Backend
cd Backend
mvn spring-boot:run

# Terminal 2 - Start Frontend
cd Frontend
# Open index.html in browser or use:
python -m http.server 3000
```

**Access**: http://localhost:3000

---

### Option 2: Docker Compose (Easiest)

Run everything in containers with one command:

```bash
# Build and start all services (frontend, backend, mysql)
docker-compose up -d

# View logs
docker-compose logs -f

# Stop everything
docker-compose down
```

**Access**: 
- Frontend: http://localhost
- Backend: http://localhost:8080
- MySQL: localhost:3306

**What it does**: 
- Builds Docker images from your Frontend/Backend code
- Starts MySQL, Backend, and Frontend containers
- Connects them all together

---

### Option 3: Kubernetes with Ingress (Production)

Deploy to Kubernetes cluster (EKS, GKE, etc.):

```bash
# 1. Build and push Docker images to registry
docker build -t 804329959270.dkr.ecr.ap-south-1.amazonaws.com/backend:latest ./Backend
docker build -t 804329959270.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest ./Frontend

docker push 804329959270.dkr.ecr.ap-south-1.amazonaws.com/backend:latest
docker push 804329959270.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest

# 2. Deploy to Kubernetes
bash deploy-all.sh

# Or manually:
kubectl apply -f mysql-secret.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
kubectl apply -f ingress.yaml

# 3. Get the public URL
kubectl get ingress app-ingress
```

**Access**: http://<INGRESS-ADDRESS>/

---

## Step-by-Step: From Code to Kubernetes

### Step 1: Test Locally First
```bash
cd Backend
mvn clean package
java -jar target/*.jar
```

### Step 2: Test with Docker Compose
```bash
docker-compose up -d
# Test at http://localhost
docker-compose down
```

### Step 3: Build Images for Registry
```bash
# Login to ECR
aws ecr get-login-password --region ap-south-1 | \
  docker login --username AWS --password-stdin 804329959270.dkr.ecr.ap-south-1.amazonaws.com

# Build
cd Backend
docker build -t 804329959270.dkr.ecr.ap-south-1.amazonaws.com/backend:latest .

cd ../Frontend
docker build -t 804329959270.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest .

# Push
docker push 804329959270.dkr.ecr.ap-south-1.amazonaws.com/backend:latest
docker push 804329959270.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest
```

### Step 4: Deploy to Kubernetes
```bash
# Deploy everything
bash deploy-all.sh

# Monitor deployment
kubectl get pods --watch
```

### Step 5: Access Your Application
```bash
# Get the URL
kubectl get ingress app-ingress

# Access at:
# http://<ADDRESS>/        - Frontend
# http://<ADDRESS>/api/v3  - Backend API
```

---

## Architecture

### Local Development:
```
Browser → Frontend (localhost:3000) → Backend (localhost:8080) → MySQL (localhost:3306)
```

### Docker Compose:
```
Browser → Frontend Container (:80) → Backend Container (:8080) → MySQL Container (:3306)
```

### Kubernetes:
```
Internet → Ingress (ALB) → Frontend Service → Frontend Pods
                         ↓
                         → Backend Service → Backend Pods → MySQL Service → MySQL Pod
```

---

## Your Application Features

Based on your code, the application supports:
- ✅ Create User (POST /api/v3/adduser)
- ✅ Get All Users (GET /api/v3/getusers)
- ✅ Get User by ID (GET /api/v3/getuser/{id})
- ✅ Update User (PUT /api/v3/updateuser)
- ✅ Delete User (DELETE /api/v3/deleteuser/{id})

---

## Troubleshooting

### Frontend can't connect to backend:
```bash
# Check if backend is running
kubectl get pods -l app=backend

# Check backend logs
kubectl logs -l app=backend

# Port forward for testing
kubectl port-forward service/backend-service 8080:8080
```

### Database connection issues:
```bash
# Check MySQL pod
kubectl get pods -l app=mysql

# Check MySQL logs
kubectl logs -l app=mysql

# Verify secret
kubectl get secret mysql-secret
```

### Ingress not getting ADDRESS:
```bash
# Check ingress status
bash check-ingress.sh

# Troubleshoot
bash troubleshoot-ingress.sh
```

---

## Quick Commands

```bash
# See everything
kubectl get all

# Check logs
kubectl logs -l app=backend --tail=50
kubectl logs -l app=frontend --tail=50

# Restart deployment
kubectl rollout restart deployment backend
kubectl rollout restart deployment frontend

# Delete everything
kubectl delete -f backend-deployment.yaml
kubectl delete -f frontend-deployment.yaml
kubectl delete -f mysql-deployment.yaml
```

---

## Summary

**This is NOT a separate project!** 

The Docker and Kubernetes files deploy YOUR existing User Management System:
- Your **Frontend** folder → Gets packaged into frontend Docker image
- Your **Backend** folder → Gets packaged into backend Docker image
- Both deploy together with MySQL in Kubernetes

Choose your deployment method based on your needs:
- 🏠 **Local**: Quick testing during development
- 🐳 **Docker Compose**: Local production-like environment
- ☸️ **Kubernetes**: Production deployment with scaling & high availability
