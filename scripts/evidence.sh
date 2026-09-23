#!/usr/bin/env bash
set -euo pipefail
out=incident-2026-09-23; mkdir -p "$out"
kubectl get nodes -o wide > "$out/kubectl-nodes.txt"
kubectl get pods -A -o wide > "$out/kubectl-pods.txt"
kubectl get events -A --sort-by=.lastTimestamp > "$out/kubectl-events.txt"
kubectl describe nodes > "$out/kubectl-node-describe.txt"
kubectl describe deployment/settle-api -n settle > "$out/kubectl-api-describe.txt"
kubectl logs deployment/settle-api -n settle --all-containers > "$out/api.log" || true
kubectl logs deployment/settle-worker -n settle --all-containers > "$out/worker.log" || true
kubectl logs statefulset/postgres -n settle --all-containers > "$out/postgres.log" || true
df -h > "$out/node-df.txt"
kubectl get hpa -n settle > "$out/hpa.txt"
kubectl top nodes > "$out/node-top.txt" 2>&1 || true
kubectl top pods -A > "$out/pod-top.txt" 2>&1 || true
echo "evidence captured in $out"
