# User Management System - Kubernetes Deployment

A full-stack user management application with Spring Boot backend, vanilla JavaScript frontend, deployed on Kubernetes with CI/CD pipeline.

## 🏗️ Architecture

```
Frontend (HTML/CSS/JS) → Backend (Spring Boot) → MySQL Database
```

**Deployed on**: Kubernetes with Ingress for external access

## 🚀 Features

- ✅ Create, Read, Update, Delete Users
- ✅ RESTful API with Spring Boot
- ✅ Responsive UI with vanilla JavaScript
- ✅ MySQL database for persistence
- ✅ Docker containerization
- ✅ Kubernetes orchestration
- ✅ Jenkins CI/CD pipeline
- ✅ AWS ECR for container registry

## 📋 Prerequisites

- Java 17+
- Maven 3.9+
- Node.js 20+
- Docker & Docker Compose
- Kubernetes cluster (EKS/GKE/Minikube)
- kubectl CLI
- AWS CLI (for ECR)
- Jenkins (optional, for CI/CD)

## 🛠️ Local Development

### Backend
```bash
cd Backend
mvn spring-boot:run
```
Access: http://localhost:8080

### Frontend
```bash
cd Frontend
# Open index.html in browser
# Or serve with:
python -m http.server 3000
```
Access: http://localhost:3000

## 🐳 Docker Deployment

### Using Docker Compose
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

**Access**:
- Frontend: http://localhost
- Backend: http://localhost:8080
- MySQL: localhost:3306

## ☸️ Kubernetes Deployment

### Prerequisites
```bash
# Install kubectl
# Configure kubeconfig for your cluster

# Login to AWS ECR
aws ecr get-login-password --region ap-south-1 | \
  docker login --username AWS --password-stdin 804329959270.dkr.ecr.ap-south-1.amazonaws.com
```

### Build and Push Images
```bash
# Backend
cd Backend
docker build -t 804329959270.dkr.ecr.ap-south-1.amazonaws.com/backend:latest .
docker push 804329959270.dkr.ecr.ap-south-1.amazonaws.com/backend:latest

# Frontend
cd Frontend
docker build -t 804329959270.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest .
docker push 804329959270.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest
```

### Deploy to Kubernetes
```bash
# Quick deploy
bash deploy-all.sh

# Or manual deployment
kubectl apply -f mysql-secret.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
kubectl apply -f ingress.yaml
```

### Setup Ingress Controller
```bash
# Install ingress controller
bash setup-ingress.sh

# Check ingress status
kubectl get ingress app-ingress
```

### Access Application
```bash
# Get ingress address
kubectl get ingress app-ingress

# Access at:
# http://<INGRESS-ADDRESS>/        - Frontend
# http://<INGRESS-ADDRESS>/api/v3  - Backend API
```

## 🔄 CI/CD Pipeline

### Jenkins Setup

1. **Install Jenkins Plugins**:
   - Git Plugin
   - Pipeline Plugin
   - Docker Pipeline
   - Kubernetes CLI Plugin

2. **Configure Jenkins Credentials**:
   - GitHub credentials (username/token)
   - AWS credentials (for ECR)
   - Kubernetes config (optional)

3. **Create Pipeline Job**:
   ```
   - New Item → Pipeline
   - Pipeline from SCM
   - SCM: Git
   - Repository: https://github.com/RashmikaHarshamal/Kubernetes-deployement.git
   - Script Path: Jenkinsfile
   ```

4. **Configure Webhook** (optional):
   - GitHub → Settings → Webhooks
   - Add webhook: http://JENKINS-URL/github-webhook/

### Pipeline Stages

```
1. Checkout      → Pull code from GitHub
2. Build Backend → Maven compile
3. Test Backend  → Run unit tests
4. Build Frontend→ npm build
5. Docker Build  → Create images
6. Push to ECR   → Push images to registry
7. Deploy K8s    → Apply manifests
```

## 📁 Project Structure

```
.
├── Backend/                 # Spring Boot application
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile
│   └── .dockerignore
├── Frontend/               # HTML/CSS/JS application
│   ├── app.js
│   ├── index.html
│   ├── style.css
│   ├── package.json
│   ├── Dockerfile
│   └── .dockerignore
├── *.yaml                  # Kubernetes manifests
├── docker-compose.yml      # Docker Compose config
├── Jenkinsfile            # CI/CD pipeline
├── deploy-all.sh          # Deployment script
└── README.md
```

## 🔧 Configuration

### Environment Variables

**Backend** (Spring Boot):
```yaml
SPRING_DATASOURCE_URL: jdbc:mysql://mysql-service:3306/userdb
SPRING_DATASOURCE_USERNAME: userapp
SPRING_DATASOURCE_PASSWORD: userpassword
```

**Frontend**:
```javascript
API_BASE_URL: /api/v3  # Uses same domain via Ingress
```

### Kubernetes Resources

- **Replicas**: 2 (frontend & backend)
- **Backend**: 512Mi-1Gi memory, 250m-500m CPU
- **Frontend**: 128Mi-256Mi memory, 100m-200m CPU
- **MySQL**: 5Gi persistent storage

## 📊 Monitoring

```bash
# Check pod status
kubectl get pods

# View logs
kubectl logs -l app=backend
kubectl logs -l app=frontend
kubectl logs -l app=mysql

# Check resources
kubectl top pods

# View events
kubectl get events --sort-by='.lastTimestamp'
```

## 🐛 Troubleshooting

### Backend not starting
```bash
kubectl describe pod <backend-pod>
kubectl logs <backend-pod>
# Check MySQL connection
```

### Ingress not getting ADDRESS
```bash
bash check-ingress.sh
bash troubleshoot-ingress.sh
```

### Database connection failed
```bash
# Check secret
kubectl get secret mysql-secret -o yaml

# Check MySQL pod
kubectl exec -it <mysql-pod> -- mysql -u userapp -p
```

## 📚 Additional Documentation

- [DEPLOYMENT-GUIDE.md](DEPLOYMENT-GUIDE.md) - Detailed deployment instructions
- [GITHUB-INTEGRATION.md](GITHUB-INTEGRATION.md) - GitHub & Jenkins setup
- [k8s-commands.sh](k8s-commands.sh) - Useful kubectl commands

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📝 License

This project is open source and available under the MIT License.

## 👤 Author

Rashmika Harshamal - [@RashmikaHarshamal](https://github.com/RashmikaHarshamal)

**Repository**: [Kubernetes-deployement](https://github.com/RashmikaHarshamal/Kubernetes-deployement)

## 🙏 Acknowledgments

- Spring Boot documentation
- Kubernetes documentation
- Docker documentation

---

**Note**: Update registry URLs, GitHub repository links, and credentials before deploying to production.
# Kubernetes-deployement
