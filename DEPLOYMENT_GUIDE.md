# 🚀 Deployment Guide - Soutenance

## Quick Start (Pour la Soutenance)

### 1️⃣ Everything Already Running ✅

Le projet est **déjà déployé** sur ton Kubernetes local:

```bash
# Vérifier tous les services
kubectl get pods -n education
kubectl get svc -n education

# Accès Frontend
http://localhost:31927

# Login: admin@school.com / admin12345
```

### 2️⃣ Service Endpoints

| Service | URL | Port |
|---------|-----|------|
| **Frontend** | http://localhost:31927 | 31927 (NodePort) |
| **Gateway** | http://localhost:31000 | 31000 (NodePort) |
| **Grafana** | http://localhost:30500 | 30500 (NodePort) |
| **Prometheus** | http://localhost:30090 | 30090 (NodePort) |

### 3️⃣ Functionality Demo

#### Activity Management
- ✅ List Activities: `Activités & Suivi`
- ✅ Add Activity: Click `+ Ajouter`
- ✅ Auto-reload on add
- ✅ Real-time API calls

#### Teacher Management  
- ✅ List Teachers: `Intervenants spécialisés`
- ✅ Add Teacher: Click `+ Ajouter`
- ✅ Form validation with red asterisks
- ✅ Auto-reload on add

### 4️⃣ Backend Services

All services running in namespace `education`:

```bash
# Activity Service (port 3003)
kubectl logs -n education deployment/activity-service-deployment

# Teacher Service (port 3007)
kubectl logs -n education deployment/teacher-service-deployment

# Gateway (port 3001)
kubectl logs -n education deployment/gateway-backend-deployment

# Database
kubectl get secrets -n education
```

### 5️⃣ Docker Images (Docker Hub)

All images tagged and ready for production:

```
docker.io/imen2016/horizons-frontend:v1
docker.io/imen2016/devopspfe-activity-service:v1
docker.io/imen2016/devopspfe-teacher-service:v1
docker.io/imen2016/devopspfe-gateway-backend:v1
```

### 6️⃣ ArgoCD Configuration (Disabled)

ArgoCD is **disabled** to prevent auto-rollbacks during soutenance.

If you want to re-enable:

```bash
# Apply project
kubectl apply -f argocd/projects/education-project.yaml

# Apply applications
kubectl apply -f argocd/applications/

# Check status
argocd app list
argocd app get frontend-app
```

### 7️⃣ Monitoring

**Grafana Dashboard:**
- URL: http://localhost:30500
- User: admin / admin (default)
- Import dashboards for Kubernetes metrics

**Prometheus:**
- URL: http://localhost:30090
- Queries: `up`, `container_memory_usage_bytes`, etc.

### 8️⃣ Database

PostgreSQL with pre-seeded data:

```bash
# Connect
kubectl exec -it -n education postgres-deployment-xxx -- psql -U education -d education_db

# Check tables
\dt

# Query example
SELECT * FROM teacher LIMIT 5;
```

### 9️⃣ Troubleshooting

#### Frontend not loading?
```bash
# Check pod
kubectl get pods -n education | grep frontend

# Check logs
kubectl logs -n education deployment/frontend-app-deployment

# Clear cache: Ctrl+Shift+Delete in browser
```

#### Activity/Teacher endpoints return 500?
```bash
# Check respective service logs
kubectl logs -n education deployment/activity-service-deployment --tail=50

# Check gateway logs
kubectl logs -n education deployment/gateway-backend-deployment --tail=50
```

#### Database connection issues?
```bash
# Check Postgres pod
kubectl get pods -n education | grep postgres

# Check credentials in deployment
kubectl get secret -n education
```

## Architecture

```
┌─────────────────────────────────────┐
│         Frontend (Angular)          │
│   http://localhost:31927            │
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│    Gateway (NestJS) :3001           │
│   http://localhost:31000            │
└──┬──────────────┬──────────────┬────┘
   │              │              │
   ▼              ▼              ▼
Activity      Teacher        Other
Service       Service        Services
:3003         :3007
   │              │              │
   └──────────────┼──────────────┘
                  ▼
         ┌────────────────┐
         │   PostgreSQL   │
         │   localhost    │
         └────────────────┘
```

## For Production

1. Push images to Docker Hub ✅
2. Create Kubernetes manifests in `backend/*/kubernetes/`
3. Enable ArgoCD sync
4. Set up CI/CD pipeline (GitHub Actions)
5. Configure TLS certificates
6. Setup persistent volumes for Postgres

## Notes

- All services use **internal DNS** (Kubernetes service discovery)
- Frontend uses relative API URLs → reroutes to gateway:31000
- Gateway forwards to internal services on ports 3001-3007
- Database is **single instance** (for demo), use replicas in production
- No Ingress configured (using NodePorts)

---

**Created for: Horizons TSA - DevOps Education Platform**
**Soutenance Ready: ✅**
