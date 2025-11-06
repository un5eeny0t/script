#!/bin/bash

set -e

echo "[+] Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "[+] Removing old Docker versions (if any)..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

echo "[+] Installing dependencies..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https software-properties-common

echo "[+] Adding Docker’s official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "[+] Setting up the Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[+] Updating package index..."
sudo apt-get update -y

echo "[+] Installing Docker Engine and Compose..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[+] Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "[+] Adding current user to 'docker' group..."
sudo usermod -aG docker $USER

echo "[+] Testing Docker installation..."
sudo docker run --rm hello-world

echo
echo "---------------------------------------------------------"
echo "[✓] Docker installation completed successfully!"
echo "[i] Your user has been added to the 'docker' group."
echo "[i] To use Docker without sudo, run: newgrp docker"
echo "[i] Then verify with: docker run hello-world"
echo "---------------------------------------------------------"
