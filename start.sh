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

echo "Starting ngrok in background..."
pkill ngrok 2>/dev/null || true
nohup ngrok http 8090 > /tmp/ngrok.log 2>&1 &
sleep 5

NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels | python3 -c "import sys,json; print(json.load(sys.stdin)['tunnels'][0]['public_url'])" 2>/dev/null)

echo ""
echo "=========================================="
echo "Jenkins:   http://localhost:8090"
echo "ngrok URL: $NGROK_URL"
echo "=========================================="
echo ""
echo "ACTION REQUIRED - do these 2 steps:"
echo ""
echo "STEP 1 - Update Jenkins URL:"
echo "  Go to: http://localhost:8090/manage/configure"
echo "  Find 'Jenkins URL' and set it to: $NGROK_URL"
echo "  Click Save"
echo ""
echo "STEP 2 - Update GitHub webhook:"
echo "  Go to: github.com/QandeLand/jenkins-cicd/settings/hooks"
echo "  Edit webhook → set Payload URL to: ${NGROK_URL}/github-webhook/"
echo "  Click Update webhook"
echo "=========================================="
