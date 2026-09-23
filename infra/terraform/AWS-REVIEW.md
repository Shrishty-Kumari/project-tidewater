# AWS review log

The assignment requires VPC/2 AZs, EKS or ECS, RDS, ElastiCache, security groups, workload IAM, secrets, remote state/locking and reusable staging/prod modules. This repository is a validation-oriented design and must not be applied to a real account for the assignment.

## Required production hardening before apply
- Add explicit security groups: ALB -> EKS ingress, EKS -> RDS 5432, EKS -> Redis 6379; no public data-plane access.
- Replace the placeholder workload trust with the real EKS OIDC provider and service account.
- Use AWS Secrets Manager/IRSA or EKS Pod Identity for application secrets. RDS master password is managed by AWS.
- Add NAT gateways/endpoints as required by the private subnet design.
- Add backup/PITR/deletion protection/KMS and CloudWatch log retention for production.

## Staging budget
Use one small EKS node, one small RDS instance and one small Redis node in staging; avoid Multi-AZ data services in staging where acceptable. Exact monthly pricing must be checked against the selected AWS region before applying.
