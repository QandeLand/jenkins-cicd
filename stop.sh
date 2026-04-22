#!/bin/bash
echo "Stopping containers..."
docker compose down
docker-compose -f docker-compose.app.yml down 2>/dev/null || true
docker compose -f docker-compose-sonar.yml down 2>/dev/null || true
docker stop sonarqube flask-app mysql-app 2>/dev/null || true
echo "Stopping ngrok..."
pkill ngrok 2>/dev/null || true
echo "Done!"
