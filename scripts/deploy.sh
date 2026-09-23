#!/usr/bin/env bash
set -euo pipefail
tag=${1:-1.9.0}
kubectl apply -f deploy/k8s/api.yaml -f deploy/k8s/worker.yaml -f deploy/k8s/hpa.yaml -f deploy/k8s/ingress.yaml
kubectl set image deployment/settle-api api=settle-api:$tag -n settle
kubectl set env deployment/settle-api APP_VERSION=$tag -n settle
kubectl set image deployment/settle-worker worker=settle-api:$tag -n settle
kubectl rollout status deployment/settle-api -n settle --timeout=180s
kubectl rollout status deployment/settle-worker -n settle --timeout=180s
