# Kubernetes Deployment Project

User Management System with Spring Boot backend and Vite frontend.

## 🚀 Quick Start

### Prerequisites
- Docker Engine 20.10+
- Docker Compose v2.0+
- Git

### Running the Application

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd "Kubernetes Deployement"
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Build and start all services**
   ```bash
   docker-compose up -d --build
   ```

   Access:
   - Frontend: http://localhost
   - Backend API: http://localhost:8080
   - MySQL: localhost:3306

4. **View logs**
   ```bash
   docker-compose logs -f
   ```

5. **Stop services**
   ```bash
   docker-compose down
   ```

6. **Remove volumes (⚠️ deletes database data)**
   ```bash
   docker-compose down -v
   ```

## 📦 Docker Services

### Backend (Spring Boot)
- Port: 8080
- Health Check: `/actuator/health`

### Frontend (Nginx)
- Port: 80

### Database (MySQL 8.0)
- Port: 3306
- Database: userdb
- Credentials in `.env` file

## 🛠️ CI/CD with Jenkins

The `Jenkinsfile` provides:
- Automated builds for frontend and backend
- Docker image creation and tagging
- Push to Docker registry
- Kubernetes deployment (configurable)

### Setup Jenkins Pipeline

1. **Configure Docker Hub credentials** in Jenkins:
   - Credentials ID: `dockerhub-credentials`

2. **Update Jenkinsfile**:
   - Replace `your-username` with your Docker Hub username

3. **Create Jenkins pipeline** pointing to repository root

## 📁 Project Structure

```
.
├── Backend/
│   ├── src/
│   ├── Dockerfile
│   ├── .dockerignore
│   └── pom.xml
├── Frontend/
│   ├── Dockerfile
│   ├── .dockerignore
│   └── package.json
├── docker-compose.yml
├── Jenkinsfile
├── .gitignore
└── .env.example
```

## 🔧 Development Tips

### Hot Reload
- Frontend: Changes auto-reload via Vite dev server
- BaDatabase Access
```bash
docker exec -it user-database mysql -u root -p
# Password: rootpassword (from .env)
```

### Clean Build
```bash
# Remove all containers, volumes, and images
docker-compose
## 🐳 Individual Container Commands

### Backend
```bash
cd Backend
docker build -t user-backend .
docker run -p 8080:8080 user-backend
```

### Frontend
```bash
cd Frontend
docker build -t user-frontend .
docker run -p 80:80 user-frontend
```

## 📝 Environment Variables

See `.env.example` for all available configuration options.

## 🤝 Contributing

1. Create feature branch
2. Make changes
3. Test with Docker Compose
4. Submit pull request

## 📄 License

[Your License Here]
# Kubernetes-deployement
