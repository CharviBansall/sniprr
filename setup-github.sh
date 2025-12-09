#!/bin/bash

# Script to set up GitHub remote and push GoViral repository
# Run this after creating the repository on GitHub

REPO_NAME="goviral"
GITHUB_USER="CharviBansall"

echo "Setting up GitHub remote for $REPO_NAME..."

# Add the remote (update the URL if you used a different repo name)
git remote add origin https://github.com/$GITHUB_USER/$REPO_NAME.git

# Or if you prefer SSH (if you have SSH keys set up):
# git remote add origin git@github.com:$GITHUB_USER/$REPO_NAME.git

# Push to GitHub
git branch -M main
git push -u origin main

echo "✅ Repository pushed to GitHub!"
echo "🔗 https://github.com/$GITHUB_USER/$REPO_NAME"

