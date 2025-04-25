#!/bin/bash

# Exit on any error
set -e

echo "==============================================="
echo "🔧 Git Push to New Repository Script"
echo "==============================================="

# Ensure we're in the correct directory (script directory)
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"  # Change to the directory where the script is located

# Confirm we are in the correct directory
echo "Current Directory: $(pwd)"

# Ask for the new GitHub repository URL
read -p "🌐 Enter the new GitHub repository URL: " NEW_REPO_URL

# Ask for the commit message
read -p "📝 Enter the commit message: " COMMIT_MSG

# Ask for the branch name (default: master)
read -p "🔑 Enter the branch name (default: master): " BRANCH_NAME
BRANCH_NAME=${BRANCH_NAME:-master}

# Ask user for preferred authentication method (PAT or SSH)
echo "Choose authentication method:"
echo "1. Personal Access Token (PAT)"
echo "2. SSH Key"
read -p "Enter 1 or 2: " AUTH_METHOD

if [ "$AUTH_METHOD" == "1" ]; then
    # Ask for GitHub username and PAT (Personal Access Token)
    read -p "👤 Enter your GitHub username: " GITHUB_USERNAME
    read -sp "🔑 Enter your GitHub Personal Access Token (PAT): " GITHUB_PAT
    echo # to move to the next line

    # Set the new remote URL with PAT
    echo "==============================================="
    echo "⚙️  Adding new remote URL with PAT..."
    git remote remove origin || true
    git remote add origin "https://${GITHUB_USERNAME}:${GITHUB_PAT}@github.com/${GITHUB_USERNAME}/$(basename $NEW_REPO_URL).git"

elif [ "$AUTH_METHOD" == "2" ]; then
    # Set the new remote URL with SSH
    echo "==============================================="
    echo "⚙️  Adding new remote URL with SSH..."
    REPO_NAME=$(basename $NEW_REPO_URL .git)  # Removes the '.git' if present
    git remote remove origin || true
    git remote add origin "git@github.com:${GITHUB_USERNAME}/${REPO_NAME}.git"
else
    echo "Invalid choice! Exiting script."
    exit 1
fi

# Ensure only files in the current directory are staged
echo "==============================================="
echo "📂 Staging changes..."
git add *    # This should now only add files within the current directory

# Confirm what files are being staged
echo "==============================================="
git status

# Commit changes
echo "==============================================="
echo "💬 Committing changes..."
git commit -m "$COMMIT_MSG"

# Push changes to the new repository
echo "==============================================="
echo "🚀 Pushing changes to the new repository..."
git push -u origin "$BRANCH_NAME"

echo "==============================================="
echo "🎉 Your changes have been successfully pushed to $NEW_REPO_URL"

