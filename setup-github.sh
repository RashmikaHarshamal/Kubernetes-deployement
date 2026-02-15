#!/bin/bash

echo "=== GitHub Repository Setup Script ==="
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "Initializing Git repository..."
    git init
    git branch -M main
else
    echo "✓ Git repository already initialized"
fi

echo ""
read -p "Enter your GitHub username: " github_user
read -p "Enter repository name [user-management-kubernetes]: " repo_name
repo_name=${repo_name:-user-management-kubernetes}

GITHUB_URL="https://github.com/${github_user}/${repo_name}.git"

echo ""
echo "Your repository URL will be: $GITHUB_URL"
echo ""
echo "IMPORTANT: Create this repository on GitHub first!"
echo "1. Go to: https://github.com/new"
echo "2. Repository name: $repo_name"
echo "3. Keep it Public or Private (your choice)"
echo "4. DO NOT initialize with README (we have files already)"
echo "5. Click 'Create repository'"
echo ""
read -p "Press Enter when repository is created on GitHub..."

echo ""
echo "Adding files to git..."
git add .

echo ""
echo "Creating initial commit..."
git commit -m "Initial commit: User Management System with Docker and Kubernetes"

echo ""
echo "Adding GitHub remote..."
git remote remove origin 2>/dev/null
git remote add origin $GITHUB_URL

echo ""
echo "Pushing to GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Successfully pushed to GitHub!"
    echo ""
    echo "Next steps:"
    echo "1. View your code: https://github.com/${github_user}/${repo_name}"
    echo "2. Setup Jenkins to use this repository"
    echo "3. Configure webhook for auto-deployment"
    echo ""
    echo "See GITHUB-INTEGRATION.md for Jenkins setup instructions"
else
    echo ""
    echo "❌ Push failed. Common issues:"
    echo "  - Repository doesn't exist on GitHub"
    echo "  - Authentication failed (use Personal Access Token)"
    echo "  - Branch protection enabled"
    echo ""
    echo "To fix authentication:"
    echo "1. Create Personal Access Token: https://github.com/settings/tokens"
    echo "2. Use token as password when prompted"
    echo "3. Or configure git credential helper"
fi
