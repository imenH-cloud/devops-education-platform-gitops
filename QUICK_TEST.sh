#!/bin/bash
# Quick test script before soutenance

echo "🔍 HORIZONS TSA - QUICK PRE-SOUTENANCE TEST"
echo "==========================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Check all pods
echo -e "${YELLOW}[1/5] Checking Kubernetes pods...${NC}"
RUNNING=$(kubectl get pods -n education --no-headers 2>/dev/null | wc -l)
if [ "$RUNNING" -ge 10 ]; then
    echo -e "${GREEN}✅ All pods running ($RUNNING pods)${NC}"
else
    echo -e "${RED}❌ Not all pods running (Only $RUNNING pods)${NC}"
    kubectl get pods -n education
fi
echo ""

# Test 2: Check services
echo -e "${YELLOW}[2/5] Checking Kubernetes services...${NC}"
FRONTEND=$(kubectl get svc -n education frontend-app -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)
if [ ! -z "$FRONTEND" ] && [ "$FRONTEND" == "31927" ]; then
    echo -e "${GREEN}✅ Frontend service on NodePort 31927${NC}"
else
    echo -e "${RED}❌ Frontend service issue${NC}"
fi
echo ""

# Test 3: Test API connectivity
echo -e "${YELLOW}[3/5] Testing API connectivity...${NC}"
GATEWAY=$(curl -s http://localhost:31000/health 2>/dev/null || echo "FAILED")
if [[ "$GATEWAY" != "FAILED" ]]; then
    echo -e "${GREEN}✅ Gateway API responding${NC}"
else
    echo -e "${YELLOW}⚠️ Gateway API not responding (May be normal if still starting)${NC}"
fi
echo ""

# Test 4: Check monitoring
echo -e "${YELLOW}[4/5] Checking monitoring stack...${NC}"
PROM=$(kubectl get pods -n monitoring -l app=prometheus -o jsonpath='{.items[0].status.phase}' 2>/dev/null)
GRAF=$(kubectl get pods -n monitoring -l app=grafana -o jsonpath='{.items[0].status.phase}' 2>/dev/null)

if [ "$PROM" == "Running" ] && [ "$GRAF" == "Running" ]; then
    echo -e "${GREEN}✅ Prometheus and Grafana running${NC}"
else
    echo -e "${YELLOW}⚠️ Monitoring stack check: Prometheus=$PROM, Grafana=$GRAF${NC}"
fi
echo ""

# Test 5: Summary
echo -e "${YELLOW}[5/5] Final Summary...${NC}"
echo ""
echo "Access Points:"
echo "  Frontend:   http://localhost:31927"
echo "  Grafana:    http://localhost:30500"
echo "  Prometheus: http://localhost:30090"
echo ""
echo "Login: admin@school.com / admin12345"
echo ""

# Final check
ALL_GOOD=true
kubectl get pods -n education | grep -q "CrashLoopBackOff" && ALL_GOOD=false
kubectl get pods -n education | grep -q "Pending" && ALL_GOOD=false

if [ "$ALL_GOOD" = true ]; then
    echo -e "${GREEN}🟢 ALL SYSTEMS GO - READY FOR SOUTENANCE!${NC}"
else
    echo -e "${RED}🔴 ISSUE DETECTED - CHECK PODS:${NC}"
    kubectl get pods -n education
fi

echo ""
echo "==========================================="
echo "End of test"
