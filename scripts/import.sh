#!/usr/bin/env bash
set -euo pipefail
tag=${1:-1.9.0}; k3d image import settle-api:$tag -c tidewater
