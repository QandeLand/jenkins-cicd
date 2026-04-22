#!/bin/bash
echo "Stopping containers..."
docker compose down
docker-compose -f docker-compose.app.yml down 2>/dev/null || true
echo "Stopping ngrok..."
pkill ngrok 2>/dev/null || true
echo "Done!"
