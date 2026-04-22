#!/bin/bash
echo "Stopping all containers..."
docker compose down
docker-compose -f docker-compose.app.yml down 2>/dev/null || true
echo "Done!"
