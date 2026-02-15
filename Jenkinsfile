    pipeline {
    agent any
    
    environment {
        // Docker registry configuration - UPDATE THESE
        DOCKER_REGISTRY = '804329959270.dkr.ecr.ap-south-1.amazonaws.com'
        DOCKER_CREDENTIALS_ID = 'aws-ecr-credentials'
        AWS_REGION = 'ap-south-1'
        
        // Image names
        BACKEND_IMAGE = "${DOCKER_REGISTRY}/backend"
        FRONTEND_IMAGE = "${DOCKER_REGISTRY}/frontend"
        
        // Version tag
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }
    
    tools {
        maven 'Maven-3.9'
        nodejs 'NodeJS-20'
        jdk 'JDK-17'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        
        stage('Build Backend') {
            steps {
                dir('Backend') {
                    echo 'Building Spring Boot application...'
                    sh 'mvn clean compile'
                }
            }
        }
        
        stage('Test Backend') {
            steps {
                dir('Backend') {
                    echo 'Running backend tests...'
                    sh 'mvn test'
                }
            }
            post {
                always {
                    junit 'Backend/target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Package Backend') {
            steps {
                dir('Backend') {
                    echo 'Packaging backend application...'
                    sh 'mvn package -DskipTests'
                }
            }
        }
        
        stage('Build Frontend') {
            steps {
                dir('Frontend') {
                    echo 'Installing frontend dependencies...'
                    sh 'npm install'
                    echo 'Building frontend application...'
                    sh 'npm run build'
                }
            }
        }
        
        stage('Build Docker Images') {
            parallel {
                stage('Build Backend Image') {
                    steps {
                        dir('Backend') {
                            script {
                                echo 'Building backend Docker image...'
                                docker.build("${BACKEND_IMAGE}:${IMAGE_TAG}")
                                docker.build("${BACKEND_IMAGE}:latest")
                            }
                        }
                    }
                }
                
                stage('Build Frontend Image') {
                    steps {
                        dir('Frontend') {
                            script {
                                echo 'Building frontend Docker image...'
                                docker.build("${FRONTEND_IMAGE}:${IMAGE_TAG}")
                                docker.build("${FRONTEND_IMAGE}:latest")
                            }
                        }
                    }
                }
            }
        }
        
        stage('Push Docker Images') {
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", "${DOCKER_CREDENTIALS_ID}") {
                        echo 'Pushing backend image...'
                        docker.image("${BACKEND_IMAGE}:${IMAGE_TAG}").push()
                        docker.image("${BACKEND_IMAGE}:latest").push()
                        
                        echo 'Pushing frontend image...'
                        docker.image("${FRONTEND_IMAGE}:${IMAGE_TAG}").push()
                        docker.image("${FRONTEND_IMAGE}:latest").push()
                    }
                }
            }
        }
        
        stage('Deploy to Development') {
            when {
                branch 'develop'
            }
            steps {
                echo 'Deploying to development environment...'
                sh 'docker-compose -f docker-compose.yml up -d'
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to Production?', ok: 'Deploy'
                echo 'Deploying to production environment...'
                // Add your production deployment commands here
                // sh 'kubectl apply -f k8s/'
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
            // Add notifications (email, Slack, etc.)
        }
        
        failure {
            echo 'Pipeline failed!'
            // Add failure notifications
        }
        
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}
