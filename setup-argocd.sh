#!/bin/bash

# ArgoCD Installation & Configuration Script
# For: Horizons TSA - Education Platform

echo "🚀 Setting up ArgoCD for Horizons TSA"
echo "======================================"

# Namespace
ARGOCD_NS="argocd"
EDUCATION_NS="education"

# Create namespaces
echo "📁 Creating namespaces..."
kubectl create namespace $EDUCATION_NS 2>/dev/null || true

# Apply AppProject
echo "📊 Applying AppProject..."
kubectl apply -f argocd/projects/education-app-project.yaml

# Apply Applications
echo "🔗 Applying Applications (9 services)..."
kubectl apply -f argocd/applications/01-frontend.yaml
kubectl apply -f argocd/applications/02-all-services.yaml

# Wait a bit
sleep 5

# Show status
echo ""
echo "✅ ArgoCD Configuration Complete!"
echo ""
echo "📋 Applications Created:"
kubectl get applications -n argocd

echo ""
echo "🔗 Access ArgoCD UI:"
echo "   kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "   https://localhost:8080"
echo ""
echo "📊 Images on Docker Hub (eline2016):"
echo "   ✅ eline2016/horizons-frontend:v1"
echo "   ✅ eline2016/devopspfe-activity-service:v1"
echo "   ✅ eline2016/devopspfe-teacher-service:v1"
echo "   ✅ eline2016/devopspfe-gateway-backend:v1"
echo "   ✅ Auth, User, Parent, Student, Classroom (ready to push)"
echo ""
echo "📝 Next Steps:"
echo "   1. Create Kubernetes manifests in: kubernetes/frontend, kubernetes/activity, etc."
echo "   2. Update images in manifests to use: eline2016/..."
echo "   3. Push to GitHub"
echo "   4. ArgoCD will auto-sync!"
