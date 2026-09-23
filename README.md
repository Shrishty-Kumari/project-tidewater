# Project Tidewater

Self-contained implementation scaffold for the DevOps assignment. It includes FastAPI API, Redis worker, PostgreSQL 15, k3d Kubernetes manifests, CI workflow, rollback script, Prometheus/Grafana rules, Terraform AWS design, migrations, and required documentation.

## Quick start

```bash
make up
make build
make import
make migrate
make deploy
make smoke
```

Bad release demo:

```bash
make build-bad
make import-bad
./scripts/pipeline.sh settle-api:1.9.1-rc
```
