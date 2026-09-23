module "vpc" { source="./modules/vpc" name=var.name environment=var.environment vpc_cidr=var.vpc_cidr }
module "rds" { source="./modules/rds" name=var.name environment=var.environment subnet_ids=module.vpc.database_subnet_ids vpc_id=module.vpc.vpc_id }
module "redis" { source="./modules/redis" name=var.name environment=var.environment subnet_ids=module.vpc.database_subnet_ids vpc_id=module.vpc.vpc_id }
module "eks" { source="./modules/eks" name=var.name environment=var.environment subnet_ids=module.vpc.private_subnet_ids vpc_id=module.vpc.vpc_id }

module "iam" { source="./modules/iam" name=var.name }
