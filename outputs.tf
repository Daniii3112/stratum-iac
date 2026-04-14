output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
  sensitive   = true
}

output "rds_secret_arn" {
  description = "ARN of RDS password secret"
  value       = module.rds.secret_arn
}

output "assets_bucket" {
  description = "S3 assets bucket name"
  value       = module.s3.assets_bucket_id
}