pipeline {
    agent any
    
    environment {
        // Docker Hub credentials (configure in Jenkins)
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        
        // Image names
        BACKEND_IMAGE = "${DOCKER_REGISTRY}/rashmikaharshamal/backend"
        FRONTEND_IMAGE = "${DOCKER_REGISTRY}/rashmikaharshamal/frontend"
        
        // Build version
        BUILD_VERSION = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Backend') {
            steps {
                dir('Backend') {
                    script {
                        echo 'Building Backend Docker Image...'
                        sh """
                            docker build -t ${BACKEND_IMAGE}:${BUILD_VERSION} .
                            docker tag ${BACKEND_IMAGE}:${BUILD_VERSION} ${BACKEND_IMAGE}:latest
                        """
                    }
                }
            }
        }
        
        stage('Build Frontend') {
            steps {
                dir('Frontend') {
                    script {
                        echo 'Building Frontend Docker Image...'
                        sh """
                            docker build -t ${FRONTEND_IMAGE}:${BUILD_VERSION} .
                            docker tag ${FRONTEND_IMAGE}:${BUILD_VERSION} ${FRONTEND_IMAGE}:latest
                        """
                    }
                }
            }
        }
        
        stage('Test Backend') {
            steps {
                dir('Backend') {
                    script {
                        echo 'Running Backend Tests...'
                        sh './mvnw test'
                    }
                }
            }
        }
        
        stage('Push Images') {
            steps {
                script {
                    echo 'Pushing Docker Images to Registry...'
                    docker.withRegistry("https://${DOCKER_REGISTRY}", "${DOCKER_CREDENTIALS_ID}") {
                        sh """
                            docker push ${BACKEND_IMAGE}:${BUILD_VERSION}
                            docker push ${BACKEND_IMAGE}:latest
                            docker push ${FRONTEND_IMAGE}:${BUILD_VERSION}
                            docker push ${FRONTEND_IMAGE}:latest
                        """
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo 'Deploying to Kubernetes...'
                    // Update this section with your Kubernetes deployment commands
                    sh """
                        # kubectl set image deployment/backend backend=${BACKEND_IMAGE}:${BUILD_VERSION}
                        # kubectl set image deployment/frontend frontend=${FRONTEND_IMAGE}:${BUILD_VERSION}
                        # kubectl rollout status deployment/backend
                        # kubectl rollout status deployment/frontend
                        echo "Kubernetes deployment commands are commented out. Configure as needed."
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
            // Add notifications (e.g., Slack, email)
        }
        failure {
            echo 'Pipeline failed!'
            // Add failure notifications
        }
        always {
            // Clean up
            sh """
                docker image prune -f
            """
        }
    }
}
