#!/bin/bash

# Download the latest stable release of kubectl
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/windows/amd64/kubectl.exe"

# Create a directory to store kubectl (if it doesn't exist)
mkdir -p /c/kubectl

# Move kubectl.exe to the created directory
mv kubectl.exe /c/kubectl/

# Add to PATH manually (inform the user)
echo "✅ kubectl downloaded successfully."

echo "⚡ IMPORTANT: Add 'C:\\kubectl' to your Windows System Environment Variables -> PATH manually if not already added."

# Verify kubectl version
/c/kubectl/kubectl.exe version --client
