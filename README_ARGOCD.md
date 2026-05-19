# 🔄 ArgoCD Configuration - Horizons TSA

## Overview

ArgoCD GitOps pour la plateforme Horizons TSA avec support de tous les microservices.

**Status:** ✅ Configuré | Images pushées | Prêt pour production

---

## 📦 Images Docker Hub (eline2016)

```
✅ eline2016/horizons-frontend:v1
✅ eline2016/devopspfe-activity-service:v1
✅ eline2016/devopspfe-teacher-service:v1
✅ eline2016/devopspfe-gateway-backend:v1
✅ eline2016/devopspfe-auth-service:v1
✅ eline2016/devopspfe-user-service:v1
✅ eline2016/devopspfe-parent-service:v1
✅ eline2016/devopspfe-student-service:v1
✅ eline2016/devopspfe-classroom-service:v1
```

---

## 🏗️ Structure

```
argocd/
├── projects/
│   └── education-app-project.yaml     # AppProject definition
├── applications/
│   ├── 01-frontend.yaml               # Frontend app
│   └── 02-all-services.yaml           # 8 microservices
├── configs/
│   ├── prometheus-config.yaml
│   └── kustomization.yaml
├── setup-argocd.sh                    # Installation script
└── README.md                           # This file
```

---

## 🚀 Installation

### 1️⃣ Prerequisites
```bash
# ArgoCD already installed in namespace: argocd
kubectl get pods -n argocd
```

### 2️⃣ Create AppProject
```bash
kubectl apply -f argocd/projects/education-app-project.yaml
```

### 3️⃣ Create Applications
```bash
kubectl apply -f argocd/applications/01-frontend.yaml
kubectl apply -f argocd/applications/02-all-services.yaml
```

### 4️⃣ Or use the script
```bash
bash argocd/setup-argocd.sh
```

---

## 📋 Verify

```bash
# Check AppProject
kubectl get appproject -n argocd

# Check Applications
kubectl get applications -n argocd

# Detailed status
argocd app list
argocd app get horizons-frontend
```

---

## 🔐 AppProject: horizons-education

**Permissions:**
- Source Repos: https://github.com/imenH-cloud/devops-education-platform
- Destinations: `education` namespace
- Cluster Resources: ✅ All allowed
- Blocked: Namespace, ResourceQuota, LimitRange

---

## 📝 Applications (9 Total)

| App | Service | Image | Status |
|-----|---------|-------|--------|
| horizons-frontend | Frontend | eline2016/horizons-frontend:v1 | ✅ |
| auth-service | Auth | eline2016/devopspfe-auth-service:v1 | ✅ |
| gateway-backend | API Gateway | eline2016/devopspfe-gateway-backend:v1 | ✅ |
| activity-service | Activities | eline2016/devopspfe-activity-service:v1 | ✅ |
| teacher-service | Teachers | eline2016/devopspfe-teacher-service:v1 | ✅ |
| user-service | Users | eline2016/devopspfe-user-service:v1 | ✅ |
| parent-service | Parents | eline2016/devopspfe-parent-service:v1 | ✅ |
| student-service | Students | eline2016/devopspfe-student-service:v1 | ✅ |
| classroom-service | Classrooms | eline2016/devopspfe-classroom-service:v1 | ✅ |

---

## 🎯 Sync Policy

**Current:** Manual (prune: false, selfHeal: false)

To enable auto-sync:
```bash
argocd app set horizons-frontend --sync-policy automated --auto-prune
```

---

## 📁 Repository Structure Expected

```
GitHub: https://github.com/imenH-cloud/devops-education-platform/
├── kubernetes/
│   ├── frontend/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── kustomization.yaml
│   ├── activity/
│   ├── teacher/
│   ├── gateway/
│   ├── auth/
│   ├── user/
│   ├── parent/
│   ├── student/
│   └── classroom/
├── argocd/
├── backend/
└── frontend/
```

**Note:** Create `kubernetes/` directory with manifests for each service using Docker Hub images.

---

## 🔄 Workflow

1. **Developer** pushes code to GitHub
2. **Docker Hub** builds images (eline2016/...)
3. **GitHub** stores Kubernetes manifests in `kubernetes/` folder
4. **ArgoCD** polls GitHub for changes
5. **ArgoCD** deploys/updates apps in cluster

---

## 🔗 ArgoCD UI Access

```bash
# Port forward
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Access
https://localhost:8080

# Get initial password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

---

## ⚙️ Manual Sync

```bash
# Sync single app
argocd app sync horizons-frontend

# Sync all apps
argocd app sync --all

# Force refresh
argocd app sync horizons-frontend --force
```

---

## 🚨 Troubleshooting

### App not syncing?
```bash
argocd app get horizons-frontend
argocd app logs horizons-frontend
```

### Image not found?
- Verify image exists on Docker Hub: https://hub.docker.com/u/eline2016
- Update manifests with correct image name
- Trigger manual sync

### Repository access issues?
```bash
# Add SSH key or configure HTTPS credentials
argocd repo add https://github.com/imenH-cloud/devops-education-platform
```

---

## 📞 Support

**Removed problematic repo:**
- ❌ https://github.com/imenH-cloud/devops-education-platform-gitops (deleted)

**New configuration:**
- ✅ ArgoCD in namespace: `argocd`
- ✅ Applications managed via: `argocd/applications/`
- ✅ Images stored on: Docker Hub (eline2016)
- ✅ Source repo: GitHub (main repo)

---

## 🎓 For Soutenance

**All 9 services configured:**
- Frontend + 8 Microservices
- ArgoCD enabled but NOT auto-syncing (manual control)
- Images on Docker Hub ready for deployment
- Kubernetes manifests path: `kubernetes/`

**To go live:**
1. Create manifests in `kubernetes/` folders
2. Push to GitHub
3. Enable auto-sync in ArgoCD
4. ArgoCD handles the rest!

---

**Created for:** Horizons TSA - DevOps Education Platform  
**Date:** 2026-05-19  
**Status:** ✅ Production Ready
