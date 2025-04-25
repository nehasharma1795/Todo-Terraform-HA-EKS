#✅ Installs Git
#✅ Sets up SSH keys
#✅ Downloads and configures Docker from official binaries
#✅ Removes Podman (if any)
#✅ Starts Docker service
#✅ Configures Git global settings

#!/bin/bash

# Exit on error
set -e

# Config
EMAIL="nehas91156@gmail.com"
DOCKER_VERSION="25.0.3"
DOCKER_TGZ="docker-${DOCKER_VERSION}.tgz"
DOCKER_URL="https://download.docker.com/linux/static/stable/x86_64/${DOCKER_TGZ}"

echo "==============================================="
echo "Step 1: Updating system and installing Git, wget..."
echo "==============================================="

sudo apt update -y
sudo apt install -y git curl wget

echo "Git version:"
git --version

echo "==============================================="
echo "Step 2: Generating SSH key for $EMAIL..."
echo "==============================================="

ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f ~/.ssh/id_rsa -N ""

echo "==============================================="
echo "Step 3: Setting up authorized_keys..."
echo "==============================================="

mkdir -p ~/.ssh
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
cat ~/.ssh/authorized_keys

echo "==============================================="
echo "Step 4: Downloading Docker binaries..."
echo "==============================================="

wget $DOCKER_URL -O /tmp/$DOCKER_TGZ
tar -xzvf /tmp/$DOCKER_TGZ -C /tmp

echo "Copying Docker binaries to /usr/bin..."
sudo cp /tmp/docker/* /usr/bin/

echo "==============================================="
echo "Step 5: Creating Docker systemd service..."
echo "==============================================="

sudo bash -c 'cat > /etc/systemd/system/docker.service <<EOF
[Unit]
Description=Docker Service
After=network.target

[Service]
ExecStart=/usr/bin/dockerd
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

echo "==============================================="
echo "Step 6: Enabling and starting Docker..."
echo "==============================================="

sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl start docker

echo "==============================================="
echo "Step 7: Fixing Docker directory permissions..."
echo "==============================================="

sudo chown root:root /var/lib/docker || true
sudo chmod 711 /var/lib/docker || true
sudo chmod 666 /run/docker.sock || true

echo "==============================================="
echo "Step 8: Removing Podman if installed..."
echo "==============================================="

sudo apt remove -y podman || true

echo "Killing any old Docker processes..."
DOCKER_PIDS=$(ps aux | grep dockerd | grep -v grep | awk '{print $2}')
for pid in $DOCKER_PIDS; do
    echo "Killing PID $pid"
    sudo kill -9 $pid
done

echo "Restarting Docker..."
sudo systemctl start docker
sudo systemctl restart docker
sudo systemctl status docker

echo "==============================================="
echo "Step 9: Git user configuration..."
echo "==============================================="

git config --global user.name "Neha Sharma"
git config --global user.email "$EMAIL"

echo "✅ All done! Git and Docker setup completed successfully on Ubuntu."
