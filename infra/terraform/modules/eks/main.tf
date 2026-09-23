variable "name" {type=string} variable "environment" {type=string} variable "subnet_ids" {type=list(string)} variable "vpc_id" {type=string}

data "aws_iam_policy_document" "cluster_assume" { statement { actions=["sts:AssumeRole"] principals { type="Service" identifiers=["eks.amazonaws.com"] } } }
data "aws_iam_policy_document" "node_assume" { statement { actions=["sts:AssumeRole"] principals { type="Service" identifiers=["ec2.amazonaws.com"] } } }
resource "aws_iam_role" "cluster" {name="${var.name}-eks-role" assume_role_policy=data.aws_iam_policy_document.cluster_assume.json}
resource "aws_iam_role_policy_attachment" "cluster" {role=aws_iam_role.cluster.name policy_arn="arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"}
resource "aws_iam_role" "node" {name="${var.name}-node-role" assume_role_policy=data.aws_iam_policy_document.node_assume.json}
resource "aws_iam_role_policy_attachment" "node_worker" {role=aws_iam_role.node.name policy_arn="arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"}
resource "aws_iam_role_policy_attachment" "node_cni" {role=aws_iam_role.node.name policy_arn="arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"}
resource "aws_iam_role_policy_attachment" "node_ecr" {role=aws_iam_role.node.name policy_arn="arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"}
resource "aws_eks_cluster" "this" {name="${var.name}-eks" role_arn=aws_iam_role.cluster.arn vpc_config {subnet_ids=var.subnet_ids endpoint_private_access=true endpoint_public_access=false} depends_on=[aws_iam_role_policy_attachment.cluster]}
resource "aws_eks_node_group" "this" {cluster_name=aws_eks_cluster.this.name node_group_name="${var.name}-nodes" node_role_arn=aws_iam_role.node.arn subnet_ids=var.subnet_ids instance_types=[var.environment=="prod" ? "t3.small" : "t3.micro"] scaling_config {desired_size=1 min_size=1 max_size=2} depends_on=[aws_iam_role_policy_attachment.node_worker,aws_iam_role_policy_attachment.node_cni,aws_iam_role_policy_attachment.node_ecr]}
