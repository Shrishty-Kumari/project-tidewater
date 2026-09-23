variable "name" {type=string} variable "environment" {type=string} variable "vpc_cidr" {type=string}
data "aws_region" "current" {}
resource "aws_vpc" "this" {cidr_block=var.vpc_cidr enable_dns_support=true enable_dns_hostnames=true tags={Name="${var.name}-vpc",Environment=var.environment}}
resource "aws_subnet" "private_a" {vpc_id=aws_vpc.this.id cidr_block="10.20.1.0/24" availability_zone="${data.aws_region.current.name}a" tags={Name="${var.name}-private-a"}}
resource "aws_subnet" "private_b" {vpc_id=aws_vpc.this.id cidr_block="10.20.2.0/24" availability_zone="${data.aws_region.current.name}b" tags={Name="${var.name}-private-b"}}
resource "aws_subnet" "db_a" {vpc_id=aws_vpc.this.id cidr_block="10.20.11.0/24" availability_zone="${data.aws_region.current.name}a" tags={Name="${var.name}-db-a"}}
resource "aws_subnet" "db_b" {vpc_id=aws_vpc.this.id cidr_block="10.20.12.0/24" availability_zone="${data.aws_region.current.name}b" tags={Name="${var.name}-db-b"}}
output "vpc_id" {value=aws_vpc.this.id} output "private_subnet_ids" {value=[aws_subnet.private_a.id,aws_subnet.private_b.id]} output "database_subnet_ids" {value=[aws_subnet.db_a.id,aws_subnet.db_b.id]}
