#!/bin/bash
echo "Starting containers..."
docker compose up -d

echo "Waiting for Jenkins to start..."
sleep 30

echo "Installing tools in Jenkins..."
docker exec --user root jenkins bash -c "
apt-get update -qq &&
apt-get install -y python3 python3-pip docker.io &&
pip3 install pytest flask mysql-connector-python --break-system-packages &&
curl -L https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose &&
chmod +x /usr/local/bin/docker-compose &&
chmod 666 /var/run/docker.sock
"

echo "Done! Jenkins available at http://localhost:8090"
