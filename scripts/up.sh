#!/usr/bin/env bash
set -euo pipefail
k3d cluster list | grep -q '^tidewater' || k3d cluster create tidewater --agents 2 --servers 1 --port "8080:80@loadbalancer"
kubectl apply -f deploy/k8s/namespace.yaml
a=deploy/k8s
kubectl apply -f "$a/postgres.yaml" -f "$a/redis.yaml" -f "$a/configmap.yaml"
kubectl wait --for=condition=ready pod -l app=postgres -n settle --timeout=180s
kubectl wait --for=condition=available deployment/redis -n settle --timeout=120s
