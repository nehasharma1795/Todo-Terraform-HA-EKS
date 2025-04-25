#!/bin/bash

# Exit if any command fails
set -e

# Prompt for the user's email associated with GitHub
read -p "Enter your email associated with GitHub: " email

# Step 1: Generate SSH key pair
echo "==============================================="
echo "Step 1: Generating SSH key for $email"
echo "==============================================="
ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/id_rsa -N ""

# Step 2: Start the SSH agent
echo "==============================================="
echo "Step 2: Starting the SSH agent..."
echo "==============================================="
eval "$(ssh-agent -s)"

# Step 3: Add the SSH private key to the agent
echo "==============================================="
echo "Step 3: Adding SSH key to the agent..."
echo "==============================================="
ssh-add ~/.ssh/id_rsa

# Step 4: Display the public key
echo "==============================================="
echo "Step 4: Your SSH public key is now generated."
echo "Please add the following SSH key to your GitHub account:"
echo "==============================================="
cat ~/.ssh/id_rsa.pub

echo "==============================================="
echo "You can now copy the public key above and follow these steps to add it to GitHub:"
echo "1. Go to https://github.com/settings/keys"
echo "2. Click 'New SSH Key'"
echo "3. Paste the copied key and give it a title (e.g., 'My Laptop SSH Key')"
echo "4. Click 'Add SSH Key'"
echo "==============================================="
echo "Your SSH key is ready for use with GitHub!"
echo "after that please execute the "ssh -T git@github.com""
echo "If everything is configured correctly, you should see:Hi your-username! You've successfully authenticated"
