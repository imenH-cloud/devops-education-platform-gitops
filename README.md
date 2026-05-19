# 🔄 ArgoCD GitOps - Horizons TSA

**Repository:** Dedicated ArgoCD configuration for Horizons TSA Education Platform

**Status:** ✅ Production Ready

---

## 📋 Overview

This repository contains all ArgoCD configurations for the Horizons TSA microservices platform:

- **9 Microservices** (Frontend + 8 Backend Services)
- **GitOps** deployment model
- **Docker Hub Images** (eline2016 registry)
- **Kubernetes** orchestration

---

##  Quick Start  

### Prerequisites
```bash
# ArgoCD installed in namespace: argocd
kubectl get pods -n argocd

# Kubernetes cluster running
kubectl cluster-info
```

### Installation
```bash
# 1. Apply AppProject
kubectl apply -f projects/education-app-project.yaml

# 2. Apply Applications (9 services)
kubectl apply -f applications/01-frontend.yaml
kubectl apply -f applications/02-all-services.yaml

# Or use the script
bash setup-argocd.sh
```

### Verify
```bash
kubectl get applications -n argocd
argocd app list
```

---

## 📁 Structure

```
.
├── projects/
│   └── education-app-project.yaml        # AppProject: horizons-education
├── applications/
│   ├── 01-frontend.yaml                  # Frontend app
│   └── 02-all-services.yaml              # 8 microservices
├── configs/
│   ├── prometheus-config.yaml            # Monitoring config
│   └── kustomization.yaml                # Kustomize manifests
├── setup-argocd.sh                       # Installation script
├── DEPLOYMENT_GUIDE.md                   # Detailed deployment guide
├── README_ARGOCD.md                      # ArgoCD configuration guide
├── QUICK_TEST.sh                         # Pre-demo test script
└── README.md                             # This file
```

---

## 🐳 Docker Hub Images (eline2016)

All images pushed and ready:

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

## 🎯 Applications (9 Services)

| App | Service | Image |
|-----|---------|-------|
| horizons-frontend | Frontend (Angular) | eline2016/horizons-frontend:v1 |
| auth-service | Authentication | eline2016/devopspfe-auth-service:v1 |
| gateway-backend | API Gateway | eline2016/devopspfe-gateway-backend:v1 |
| activity-service | Activity Management | eline2016/devopspfe-activity-service:v1 |
| teacher-service | Teacher Management | eline2016/devopspfe-teacher-service:v1 |
| user-service | User Management | eline2016/devopspfe-user-service:v1 |
| parent-service | Parent Management | eline2016/devopspfe-parent-service:v1 |
| student-service | Student Management | eline2016/devopspfe-student-service:v1 |
| classroom-service | Classroom Management | eline2016/devopspfe-classroom-service:v1 |

---

## 🔗 GitHub Integration

**Main Source Repository:**
https://github.com/imenH-cloud/devops-education-platform

**ArgoCD watches:**
- Branch: `main`
- Path: `kubernetes/` (for Kubernetes manifests)

**Note:** Kubernetes manifests should be stored in:
```
https://github.com/imenH-cloud/devops-education-platform/tree/main/kubernetes/
```

---

## 📖 Documentation

- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Detailed deployment steps
- **[README_ARGOCD.md](README_ARGOCD.md)** - ArgoCD configuration details
- **[QUICK_TEST.sh](QUICK_TEST.sh)** - Pre-demo verification script

---

## 🔄 Sync Policy

**Current:** Manual (prune: false, selfHeal: false)

```bash
# Manual sync
argocd app sync horizons-frontend
argocd app sync --all

# Enable auto-sync (optional)
argocd app set horizons-frontend --sync-policy automated --auto-prune
```

---

## 🔐 AppProject: horizons-education

**Allowed Repositories:**
- https://github.com/imenH-cloud/devops-education-platform

**Allowed Destinations:**
- `education` namespace (cluster: https://kubernetes.default.svc)
- `argocd` namespace (cluster: https://kubernetes.default.svc)
- `monitoring` namespace (cluster: https://kubernetes.default.svc)

**Cluster Resources:** ✅ All allowed  
**Blocked Resources:** Namespace, ResourceQuota, LimitRange

---

## 🎬 Demo & Testing

### Pre-Demo Test
```bash
bash QUICK_TEST.sh
```

### ArgoCD UI Access
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
# https://localhost:8080
```

### Application Status
```bash
kubectl get applications -n argocd
argocd app list
argocd app get horizons-frontend
```

---

## 🚨 Troubleshooting

### Applications not appearing?
```bash
# Check if AppProject exists
kubectl get appproject -n argocd

# Check application definitions
kubectl get applications -n argocd -o wide
```

### Sync issues?
```bash
# View app details
argocd app get horizons-frontend

# View logs
kubectl logs -n argocd deployment/argocd-application-controller
```

### Repository access denied?
```bash
# Verify repository connection
argocd repo add https://github.com/imenH-cloud/devops-education-platform
```

---

## 📊 Architecture

```
┌─────────────────────────────────────┐
│      GitHub Repository              │
│  (Source Manifests + Code)          │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│       ArgoCD (This Repo)            │
│   - Applications (9 services)       │
│   - AppProject (horizons-education) │
│   - Configurations                  │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│    Kubernetes Cluster               │
│    (education namespace)            │
│    - 9 Pods running                 │
│    - Services & ConfigMaps          │
└─────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│      Docker Hub (eline2016)         │
│      - Container Images             │
│      - Pull when deploying          │
└─────────────────────────────────────┘
```

---


**All 9 services configured in ArgoCD:**
- ✅ Frontend ready
- ✅ All microservices ready
- ✅ Docker Hub images available
- ✅ Manual sync for safe demo

**Access Points:**
- Frontend: http://localhost:31927
- Grafana: http://localhost:30500
- Prometheus: http://localhost:30090

---

---


---

**Repository:** https://github.com/imenH-cloud/devops-education-platform-gitops  
**Main Project:** https://github.com/imenH-cloud/devops-education-platform  
**Docker Hub:** https://hub.docker.com/u/eline2016

--
