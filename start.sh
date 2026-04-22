#!/bin/bash
echo "Starting containers..."
docker compose up -d

echo "Waiting for Jenkins to start..."
sleep 30

echo "Installing Python packages in Jenkins..."
docker exec --user root jenkins bash -c "
apt-get update -qq &&
apt-get install -y python3 python3-pip &&
pip3 install pytest flask mysql-connector-python --break-system-packages
"

echo "Done! Jenkins available at http://localhost:8090"
