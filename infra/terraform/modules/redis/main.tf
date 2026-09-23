variable "name" {type=string} variable "environment" {type=string} variable "subnet_ids" {type=list(string)} variable "vpc_id" {type=string}
resource "aws_elasticache_subnet_group" "this" {name="${var.name}-redis" subnet_ids=var.subnet_ids}
resource "aws_elasticache_replication_group" "this" {replication_group_id="${var.name}-redis" description="Tidewater Redis" engine="redis" node_type="cache.t4g.micro" num_cache_clusters=var.environment=="prod" ? 2 : 1 port=6379 subnet_group_name=aws_elasticache_subnet_group.this.name at_rest_encryption_enabled=true transit_encryption_enabled=true}
