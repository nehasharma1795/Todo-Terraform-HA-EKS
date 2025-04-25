#!/bin/bash

# Exit on any error
set -e

echo "==============================================="
echo "🔧 Git Setup Script with Directory & Clone Option"
echo "==============================================="

# Ask for Git username, email, and GitHub username
read -p "👤 Enter your Git username (local): " GIT_USERNAME
read -p "📧 Enter your Git email: " GIT_EMAIL
read -p "🌐 Enter your GitHub username: " GITHUB_USERNAME

echo "==============================================="
echo "📂 Choose your project directory..."
echo "1) Use current directory: $(pwd)"
echo "2) Create and switch to a new directory"
read -p "Select an option (1 or 2): " dir_choice

if [[ "$dir_choice" == "2" ]]; then
    read -p "📝 Enter the name of the new directory: " NEW_DIR
    mkdir -p "$NEW_DIR"
    cd "$NEW_DIR"
    echo "📂 Switched to directory: $(pwd)"
else
    echo "✅ Using current directory: $(pwd)"
fi

echo "==============================================="
echo "🚀 Initializing Git repository..."
git init

# Configure Git globally
echo "🔧 Setting Git global configuration..."
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"
git config --global user.username "$GITHUB_USERNAME"

echo "✅ Git initialized and user configured successfully."

# Ask if user wants to clone a repository
read -p "🌐 Do you want to clone a GitHub repository into this directory? (y/n): " clone_choice

if [[ "$clone_choice" == "y" || "$clone_choice" == "Y" ]]; then
    read -p "🔗 Enter the GitHub repository URL (HTTPS or SSH): " GITHUB_REPO
    read -p "📁 Enter the folder name to clone into (leave empty to use default): " CLONE_DIR

    if [ -z "$CLONE_DIR" ]; then
        git clone "$GITHUB_REPO"
    else
        git clone "$GITHUB_REPO" "$CLONE_DIR"
    fi

    echo "✅ Repository cloned successfully."
else
    echo "📦 Skipping clone. You’re ready to start using Git here!"
fi

echo "==============================================="
echo "🎉 Git setup complete! Happy coding 🚀"
