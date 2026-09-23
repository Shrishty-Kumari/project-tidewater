# RCA — 2026-09-23 local reproduction

The hiring email states that no separate evidence bundle was supplied. Therefore this RCA does not invent the historical 14-Aug root cause. The historical facts supplied by the brief are: v1.8.0 deployed at 14:02; 14:05-14:51 intermittent 502/504s; API restart loop; node DiskPressure; 37 merchants paid twice.

## Reproduction evidence
Run `make evidence`. Evidence is stored under `incident-2026-09-23/` and should be cited by file/timestamp after the reproduction.

## Reproduced causal mechanisms
1. Dependency-sensitive liveness can create a restart storm when PostgreSQL is slow.
2. Redelivery requires payment idempotency; the fixed design uses a unique `bank_payments.idempotency_key`.
3. Connection budget is `6*10 + 2*5 = 70`, below PostgreSQL max_connections=100, leaving 30 reserve.
4. Destructive migration 0008 is unsafe; fixed sequence is expand -> compatible application -> cleanup.

## Historical claims not asserted
Without the missing evidence bundle, exact timestamps, exact double-payment sequence, and findings ruled out cannot be truthfully reconstructed. Replace this section with actual evidence if the hiring team supplies it.
