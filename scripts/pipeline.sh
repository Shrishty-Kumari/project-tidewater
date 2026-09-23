#!/usr/bin/env bash
set -euo pipefail
image=${1:?usage: ./scripts/pipeline.sh settle-api:TAG}
old=$(kubectl get deployment/settle-api -n settle -o jsonpath='{.spec.template.spec.containers[?(@.name=="api")].image}')
kubectl set image deployment/settle-api api=$image -n settle
if ! kubectl rollout status deployment/settle-api -n settle --timeout=90s; then
  echo 'rollout failed: automatic rollback'
  kubectl rollout undo deployment/settle-api -n settle
  kubectl rollout status deployment/settle-api -n settle --timeout=90s
  exit 1
fi
pod=$(kubectl get pod -n settle -l app=settle-api -o jsonpath='{.items[0].metadata.name}')
if ! kubectl exec -n settle "$pod" -- python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/healthz',timeout=3)"; then
  echo "post-deploy verification failed; rolling back to $old"
  kubectl rollout undo deployment/settle-api -n settle
  kubectl rollout status deployment/settle-api -n settle --timeout=90s
  exit 1
fi
echo 'deployment verified'
