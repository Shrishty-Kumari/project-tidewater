# RUNBOOK

## Deploy
`make build && make import && make migrate && make deploy && make smoke`

## Manual rollback
`kubectl rollout undo deployment/settle-api -n settle`

## Alerts
- **API error rate >5% for 5m:** inspect pods/logs and recent rollout; rollback if release-correlated.
- **API p95 >2s for 5m:** inspect CPU, DB connections and slow report traffic; do not only increase timeouts.
- **Worker queue >100 for 5m:** inspect workers/Redis and scale only within DB/bank capacity.
- **DB connections >80:** compare with budget; reduce pressure rather than blindly increasing max_connections.
- **Disk >80%:** inspect node and container logs; stop uncontrolled error loops and rotate logs.
