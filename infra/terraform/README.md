# AWS IaC

Design only; do not apply to a real account for this assignment.

Architecture: VPC across 2 AZs, private compute subnets, database subnets, EKS, RDS PostgreSQL, ElastiCache Redis, IAM, managed RDS password, S3 remote state with locking.

Validation: `terraform fmt -check -recursive`, `terraform init`, `terraform validate`, `tflint --recursive`, `trivy config .`.
