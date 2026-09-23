# DECISIONS

## ADR-001 EKS vs ECS
**Context:** current workload is Kubernetes. **Options:** EKS or ECS/Fargate. **Decision:** EKS, to preserve Kubernetes operational patterns. **Consequences:** lower migration friction but additional cluster complexity/cost.

## ADR-002 Migration strategy
**Context:** v1.7/v1.8 must coexist. **Decision:** expand/contract; no destructive migration during rolling deployment. **Consequence:** rollback remains schema-compatible; cleanup is delayed.

## ADR-003 Settlement idempotency
**Context:** queue delivery is at-least-once. **Decision:** unique payment idempotency key in PostgreSQL. **Consequence:** redelivery cannot create a second payment record.
