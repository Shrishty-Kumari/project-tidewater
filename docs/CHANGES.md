# CHANGES

- Separated liveness from database health to avoid restart storms.
- Added startup/readiness/liveness probes with conservative thresholds.
- Added CPU/memory requests and limits.
- Set maxUnavailable=0 for rolling updates and graceful termination windows.
- Added idempotent payment key protected by a PostgreSQL UNIQUE constraint.
- Replaced destructive 0008 with an expand migration; cleanup is delayed until old pods are gone.
- Container now runs non-root, read-only root filesystem and drops Linux capabilities.
- Added structured JSON logs and X-Request-ID propagation.
- Added HPA/database connection budget: 6 API replicas x 10 + 2 workers x 5 = 70, leaving 30 of PostgreSQL max_connections=100 as reserve.
