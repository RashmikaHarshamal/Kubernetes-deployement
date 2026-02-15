#!/bin/bash

echo "=== Installing Ingress Controller ==="
echo ""
echo "Choose your ingress controller:"
echo "1. AWS Load Balancer Controller (for EKS)"
echo "2. Nginx Ingress Controller (general purpose)"
echo ""

# Check if running on EKS
if kubectl get nodes -o json | grep -q "eks.amazonaws.com"; then
    echo "Detected EKS cluster - AWS LB Controller recommended"
    RECOMMENDED="aws"
else
    echo "Standard Kubernetes cluster - Nginx recommended"
    RECOMMENDED="nginx"
fi

echo ""
read -p "Enter choice (aws/nginx) [$RECOMMENDED]: " choice
choice=${choice:-$RECOMMENDED}

if [ "$choice" = "aws" ] || [ "$choice" = "1" ]; then
    echo ""
    echo "=== Installing AWS Load Balancer Controller ==="
    echo ""
    
    # Add EKS Helm repository
    helm repo add eks https://aws.github.io/eks-charts
    helm repo update
    
    # Install AWS Load Balancer Controller
    echo "Installing AWS Load Balancer Controller..."
    echo "Note: Ensure you have proper IAM roles configured"
    
    kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
    
    helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
      -n kube-system \
      --set clusterName=your-cluster-name \
      --set serviceAccount.create=true \
      --set serviceAccount.name=aws-load-balancer-controller
    
    echo ""
    echo "Applying ingress configuration..."
    kubectl apply -f ingress.yaml
    
elif [ "$choice" = "nginx" ] || [ "$choice" = "2" ]; then
    echo ""
    echo "=== Installing Nginx Ingress Controller ==="
    echo ""
    
    # Install Nginx Ingress Controller
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
    
    echo ""
    echo "Waiting for Nginx Ingress Controller to be ready..."
    kubectl wait --namespace ingress-nginx \
      --for=condition=ready pod \
      --selector=app.kubernetes.io/component=controller \
      --timeout=120s
    
    echo ""
    echo "Applying ingress configuration..."
    kubectl apply -f ingress-nginx.yaml
    
else
    echo "Invalid choice. Exiting."
    exit 1
fi

echo ""
echo "=== Ingress Controller Installation Complete ==="
echo ""
echo "Checking ingress status..."
kubectl get ingress

echo ""
echo "To get the ingress endpoint:"
if [ "$choice" = "nginx" ]; then
    echo "  kubectl get service -n ingress-nginx ingress-nginx-controller"
else
    echo "  kubectl get ingress app-ingress"
fi

echo ""
echo "Wait a few minutes for the load balancer to be provisioned."
echo "Then you can access your application via the external IP/hostname."
