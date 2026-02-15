#!/bin/bash

echo "=== GitHub Repository Setup ==="
echo ""
echo "✓ Repository already configured:"
echo "  https://github.com/RashmikaHarshamal/Kubernetes-deployement.git"
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "⚠ Git repository not initialized locally"
    echo "Initializing Git repository..."
    git init
    git branch -M main
    git remote add origin https://github.com/RashmikaHarshamal/Kubernetes-deployement.git
else
    echo "✓ Git repository initialized"
    
    # Check remote
    REMOTE=$(git remote get-url origin 2>/dev/null)
    if [ -z "$REMOTE" ]; then
        echo "Adding GitHub remote..."
        git remote add origin https://github.com/RashmikaHarshamal/Kubernetes-deployement.git
    else
        echo "✓ Remote configured: $REMOTE"
    fi
fi

echo ""
read -p "Do you want to push current changes to GitHub? (y/n): " push_now

if [ "$push_now" = "y" ]; then
    echo ""
    echo "Checking for changes..."
    
    if git diff-index --quiet HEAD --; then
        echo "No changes to commit"
    else
        echo "Adding all changes..."
        git add .
        
        echo ""
        read -p "Enter commit message: " commit_msg
        commit_msg=${commit_msg:-"Update project files"}
        
        echo "Creating commit..."
        git commit -m "$commit_msg"
    fi
    
    echo ""
    echo "Pushing to GitHub..."
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✓ Successfully pushed to GitHub!"
        echo ""
        echo "View your repository:"
        echo "  https://github.com/RashmikaHarshamal/Kubernetes-deployement"
    else
        echo ""
        echo "❌ Push failed. Common issues:"
        echo "  - Authentication failed (use Personal Access Token)"
        echo "  - Branch protection enabled"
        echo ""
        echo "To fix authentication:"
        echo "1. Create Personal Access Token: https://github.com/settings/tokens"
        echo "2. Use token as password when prompted"
    fi
fi

echo ""
echo "=== GitHub Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Setup Jenkins: See GITHUB-INTEGRATION.md"
echo "2. Configure webhook for auto-deployment"
echo "3. View project config: PROJECT-CONFIG.md"
