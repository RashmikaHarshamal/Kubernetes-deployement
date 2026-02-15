#!/bin/bash

echo "=== AWS CLI Setup Script ==="
echo ""

# Add snap to PATH if not already there
if ! grep -q "/snap/bin" ~/.bashrc; then
    echo 'export PATH="/snap/bin:$PATH"' >> ~/.bashrc
    echo "✓ Added /snap/bin to PATH in ~/.bashrc"
fi

# Source the bashrc
export PATH="/snap/bin:$PATH"

echo ""
echo "AWS CLI Version:"
/snap/bin/aws --version

echo ""
echo "=== AWS Configuration ==="
echo "You need to configure your AWS credentials."
echo ""
echo "Run the following command and enter your credentials:"
echo "  /snap/bin/aws configure"
echo ""
echo "You'll need:"
echo "  - AWS Access Key ID"
echo "  - AWS Secret Access Key"
echo "  - Default region name: ap-south-1"
echo "  - Default output format: json"
echo ""
echo "After configuration, login to ECR with:"
echo "  /snap/bin/aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 804329959270.dkr.ecr.ap-south-1.amazonaws.com"
echo ""
