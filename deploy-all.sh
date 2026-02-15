#!/bin/bash

echo "=== Deploying Application to Kubernetes ==="
echo ""

# Create namespace (optional)
# kubectl create namespace user-app

echo "Step 1: Creating MySQL Secret..."
kubectl apply -f mysql-secret.yaml

echo ""
echo "Step 2: Deploying MySQL Database..."
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml

echo ""
echo "Step 3: Waiting for MySQL to be ready..."
kubectl wait --for=condition=ready pod -l app=mysql --timeout=120s

echo ""
echo "Step 4: Deploying Backend Service..."
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml

echo ""
echo "Step 5: Waiting for Backend to be ready..."
kubectl wait --for=condition=ready pod -l app=backend --timeout=120s

echo ""
echo "Step 6: Deploying Frontend Service..."
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml

echo ""
echo "Step 7: Waiting for Frontend to be ready..."
kubectl wait --for=condition=ready pod -l app=frontend --timeout=120s

echo ""
echo "Step 8: Deploying Ingress..."
echo "Note: Make sure an Ingress Controller is installed first"
echo "Run 'bash setup-ingress.sh' if not already installed"
read -p "Do you want to apply ingress now? (y/n) [y]: " apply_ingress
apply_ingress=${apply_ingress:-y}

if [ "$apply_ingress" = "y" ]; then
    kubectl apply -f ingress.yaml
fi

echo ""
echo "=== Deployment Complete! ==="
echo ""
echo "Getting service information..."
kubectl get all

echo ""
echo "Getting ingress information..."
kubectl get ingress

echo ""
echo "To access the application:"
echo "  1. Via Ingress: kubectl get ingress (wait for ADDRESS)"
echo "  2. Via LoadBalancer: kubectl get service frontend-service"
echo ""
echo "To view logs:"
echo "  kubectl logs -l app=backend"
echo "  kubectl logs -l app=frontend"
echo ""
echo "To port forward for local testing:"
echo "  kubectl port-forward service/frontend-service 8080:80"
echo "  kubectl port-forward service/backend-service 8081:8080"
