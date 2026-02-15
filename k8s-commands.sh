#!/bin/bash

echo "=== Kubernetes Useful Commands ==="
echo ""

# Deployment commands
echo "--- Deploy All ---"
echo "bash deploy-all.sh"
echo ""

# Viewing resources
echo "--- View Resources ---"
echo "kubectl get all                          # All resources"
echo "kubectl get pods                         # List pods"
echo "kubectl get services                     # List services"
echo "kubectl get deployments                  # List deployments"
echo "kubectl get ingress                      # List ingress"
echo "kubectl describe pod <pod-name>          # Pod details"
echo "kubectl describe ingress app-ingress     # Ingress details"
echo ""

# Logs
echo "--- View Logs ---"
echo "kubectl logs -l app=backend              # Backend logs"
echo "kubectl logs -l app=frontend             # Frontend logs"
echo "kubectl logs -l app=mysql                # MySQL logs"
echo "kubectl logs -f <pod-name>               # Follow logs"
echo ""

# Scaling
echo "--- Scale Deployments ---"
echo "kubectl scale deployment backend --replicas=3"
echo "kubectl scale deployment frontend --replicas=3"
echo ""

# Port forwarding
echo "--- Port Forward ---"
echo "kubectl port-forward service/frontend-service 8080:80"
echo "kubectl port-forward service/backend-service 8081:8080"
echo ""

# Execute commands in pod
echo "--- Execute Commands ---"
echo "kubectl exec -it <pod-name> -- /bin/sh"
echo "kubectl exec -it <mysql-pod> -- mysql -u userapp -p"
echo ""

# Restart
echo "--- Restart ---"
echo "kubectl rollout restart deployment backend"
echo "kubectl rollout restart deployment frontend"
echo ""

# Delete resources
echo "--- Delete Resources ---"
echo "kubectl delete -f backend-deployment.yaml"
echo "kubectl delete -f frontend-deployment.yaml"
echo "kubectl delete -f mysql-deployment.yaml"
echo "kubectl delete all --all                 # Delete everything"
echo ""

# Debug
echo "--- Debug ---"
echo "kubectl describe pod <pod-name>"
echo "kubectl get events --sort-by=.metadata.creationTimestamp"
echo "kubectl top pods                         # Resource usage"
