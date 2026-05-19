#!/bin/bash
# Push images to Docker Hub imen2016

echo "=== Docker Hub Push Script ==="
echo "Registry: imen2016"
echo ""

# Login (replace with your password)
echo "Logging in to Docker Hub..."
# docker login -u imen2016 --password-stdin <<< "YOUR_PASSWORD"

# Frontend
echo "Pushing horizons-frontend:v1..."
docker push imen2016/horizons-frontend:v1

# Activity Service
echo "Pushing devopspfe-activity-service:v1..."
docker push imen2016/devopspfe-activity-service:v1

# Teacher Service
echo "Pushing devopspfe-teacher-service:v1..."
docker push imen2016/devopspfe-teacher-service:v1

# Gateway Backend
echo "Pushing devopspfe-gateway-backend:v1..."
docker push imen2016/devopspfe-gateway-backend:v1

echo ""
echo "=== Push Complete ==="
echo "Verify at: https://hub.docker.com/u/imen2016"
