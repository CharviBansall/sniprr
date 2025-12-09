#!/bin/bash

# Final script to push to GitHub once SSH key is added and repo is created

echo "🚀 Pushing GoViral to GitHub..."

cd /Users/charvibansal/Projects/goviral

# Verify SSH connection
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com 2>&1 | head -3

# Push to GitHub
echo ""
echo "Pushing code..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to GitHub!"
    echo "🔗 Repository: https://github.com/CharviBansall/goviral"
    echo ""
    echo "To add your cofounder as a collaborator:"
    echo "1. Go to https://github.com/CharviBansall/goviral/settings/access"
    echo "2. Click 'Add people'"
    echo "3. Enter their GitHub username or email"
else
    echo ""
    echo "❌ Push failed. Make sure you:"
    echo "1. Added your SSH key to GitHub (https://github.com/settings/ssh/new)"
    echo "2. Created the repository (https://github.com/new?name=goviral)"
    echo ""
    echo "Your SSH public key:"
    cat ~/.ssh/id_ed25519.pub
fi

