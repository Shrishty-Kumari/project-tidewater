terraform { backend "s3" { bucket="REPLACE-TFSTATE-BUCKET" key="tidewater/prod/terraform.tfstate" region="ap-south-1" use_lockfile=true encrypt=true } }
module "tidewater" { source="../../" name="tidewater-prod" environment="prod" aws_region="ap-south-1" }
