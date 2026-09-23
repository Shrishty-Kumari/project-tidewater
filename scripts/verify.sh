#!/usr/bin/env bash
set -euo pipefail
kubectl rollout status deployment/settle-api -n settle --timeout=60s
pod=$(kubectl get pod -n settle -l app=settle-api -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n settle "$pod" -- python -c "import urllib.request; print(urllib.request.urlopen('http://127.0.0.1:8000/healthz',timeout=3).read().decode())"
