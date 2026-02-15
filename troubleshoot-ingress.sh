#!/bin/bash

echo "=== Troubleshooting AWS Load Balancer Controller ==="
echo ""

echo "Step 1: Check if AWS Load Balancer Controller is installed"
echo "-----------------------------------------------------------"
kubectl get deployment -n kube-system aws-load-balancer-controller

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ AWS Load Balancer Controller NOT found!"
    echo ""
    echo "You need to install it first. Options:"
    echo ""
    echo "Option 1 - Using eksctl (recommended for EKS):"
    echo "  eksctl utils associate-iam-oidc-provider --cluster=your-cluster-name --approve"
    echo "  eksctl create iamserviceaccount \\"
    echo "    --cluster=your-cluster-name \\"
    echo "    --namespace=kube-system \\"
    echo "    --name=aws-load-balancer-controller \\"
    echo "    --attach-policy-arn=arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess \\"
    echo "    --approve"
    echo ""
    echo "  helm repo add eks https://aws.github.io/eks-charts"
    echo "  helm repo update"
    echo "  helm install aws-load-balancer-controller eks/aws-load-balancer-controller \\"
    echo "    -n kube-system \\"
    echo "    --set clusterName=your-cluster-name \\"
    echo "    --set serviceAccount.create=false \\"
    echo "    --set serviceAccount.name=aws-load-balancer-controller"
    echo ""
    echo "Option 2 - Use Nginx Ingress Controller instead:"
    echo "  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml"
    echo "  kubectl apply -f ingress-nginx.yaml"
    exit 1
fi

echo ""
echo "Step 2: Check controller pods"
echo "-----------------------------------------------------------"
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

echo ""
echo "Step 3: Check controller logs"
echo "-----------------------------------------------------------"
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller --tail=100

echo ""
echo "Step 4: Check IngressClass"
echo "-----------------------------------------------------------"
kubectl get ingressclass

echo ""
echo "Step 5: Check subnet tags (should be on your VPC subnets)"
echo "-----------------------------------------------------------"
echo "Your subnets need these tags:"
echo "  kubernetes.io/role/elb = 1 (for public subnets)"
echo "  kubernetes.io/cluster/your-cluster-name = shared or owned"

echo ""
echo "Step 6: Check IAM permissions"
echo "-----------------------------------------------------------"
echo "The controller needs these permissions:"
echo "  - elasticloadbalancing:*"
echo "  - ec2:DescribeSubnets"
echo "  - ec2:DescribeSecurityGroups"
echo "  - ec2:DescribeVpcs"
echo ""
echo "Check service account:"
kubectl describe serviceaccount -n kube-system aws-load-balancer-controller

echo ""
echo "Step 7: Recent events"
echo "-----------------------------------------------------------"
kubectl get events -n kube-system --sort-by='.lastTimestamp' | tail -20
