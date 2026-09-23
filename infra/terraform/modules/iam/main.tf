variable "name" {type=string}
resource "aws_iam_role" "workload" {
  name = "${var.name}-settle-workload"
  assume_role_policy = jsonencode({Version="2012-10-17",Statement=[{Effect="Allow",Principal={Federated="REPLACE-EKS-OIDC-PROVIDER"},Action="sts:AssumeRoleWithWebIdentity"}]})
}
# Replace the placeholder OIDC provider and condition with the actual EKS cluster identity before use.
