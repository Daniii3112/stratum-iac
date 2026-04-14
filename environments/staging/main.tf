terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "stratum-staging-terraform-state"
    key            = "staging/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "stratum-staging-terraform-locks"
  }
}

module "stratum" {
  source = "../../"

  environment            = "staging"
  aws_region             = "eu-west-1"
  project_name           = "stratum"
  vpc_cidr               = "10.1.0.0/16"
  availability_zones     = ["eu-west-1a", "eu-west-1b"]
  eks_cluster_version    = "1.28"
  eks_node_instance_type = "t3.large"
  eks_node_desired_size  = 2
  eks_node_min_size      = 1
  eks_node_max_size      = 5
  db_instance_class      = "db.t4g.medium"
  db_name                = "stratum_staging"
}