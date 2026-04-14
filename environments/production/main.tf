terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "stratum-production-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "stratum-production-terraform-locks"
  }
}

module "stratum" {
  source = "../../"

  environment            = "production"
  aws_region             = "eu-west-1"
  project_name           = "stratum"
  vpc_cidr               = "10.0.0.0/16"
  availability_zones     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  eks_cluster_version    = "1.28"
  eks_node_instance_type = "m5.xlarge"
  eks_node_desired_size  = 3
  eks_node_min_size      = 1
  eks_node_max_size      = 10
  db_instance_class      = "db.r6g.large"
  db_name                = "stratum"
}