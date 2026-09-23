#!/usr/bin/env bash
set -euo pipefail
tag=${1:-1.9.0}; docker build -t settle-api:$tag -f app/Dockerfile app/
