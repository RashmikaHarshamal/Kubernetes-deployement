#!/bin/bash

echo "=== Checking Ingress Status ==="
echo ""

echo "1. Ingress Resource:"
kubectl get ingress app-ingress

echo ""
echo "2. Detailed Ingress Information:"
kubectl describe ingress app-ingress

echo ""
echo "3. AWS Load Balancer Controller Logs (if available):"
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller --tail=50 2>/dev/null || echo "AWS LB Controller not found in kube-system namespace"

echo ""
echo "4. Events related to ingress:"
kubectl get events --field-selector involvedObject.name=app-ingress --sort-by='.lastTimestamp'

echo ""
echo "5. Services that ingress routes to:"
kubectl get service backend-service frontend-service

echo ""
echo "6. Checking if pods are ready:"
kubectl get pods -l app=backend
kubectl get pods -l app=frontend

echo ""
echo "=== Status Summary ==="
ADDRESS=$(kubectl get ingress app-ingress -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

if [ -z "$ADDRESS" ]; then
    echo "❌ Load Balancer is still being provisioned..."
    echo ""
    echo "This usually takes 3-5 minutes. Wait and run:"
    echo "  kubectl get ingress app-ingress"
    echo ""
    echo "Or watch for updates:"
    echo "  kubectl get ingress app-ingress --watch"
    echo ""
    echo "Common issues:"
    echo "  - AWS Load Balancer Controller not installed"
    echo "  - IAM permissions not configured"
    echo "  - Subnets not tagged properly for ALB"
    echo ""
    echo "To check if AWS LB Controller is installed:"
    echo "  kubectl get deployment -n kube-system aws-load-balancer-controller"
else
    echo "✓ Load Balancer is ready!"
    echo ""
    echo "Access your application at:"
    echo "  http://$ADDRESS/"
    echo ""
    echo "API endpoint:"
    echo "  http://$ADDRESS/api"
fi
