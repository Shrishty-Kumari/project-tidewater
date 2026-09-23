#!/usr/bin/env bash
set -euo pipefail
kubectl exec -i -n settle statefulset/postgres -- psql -U settle -d settle -v ON_ERROR_STOP=1 < migrations/0007.sql
kubectl exec -i -n settle statefulset/postgres -- psql -U settle -d settle -v ON_ERROR_STOP=1 < migrations/0008-expand.sql
echo 'safe expand migration applied'
