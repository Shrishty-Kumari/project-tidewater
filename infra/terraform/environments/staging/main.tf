terraform { backend "s3" { bucket="REPLACE-TFSTATE-BUCKET" key="tidewater/staging/terraform.tfstate" region="ap-south-1" use_lockfile=true encrypt=true } }
module "tidewater" { source="../../" name="tidewater-staging" environment="staging" aws_region="ap-south-1" }
