output "assets_bucket_id" {
  value = aws_s3_bucket.main.id
}

output "assets_bucket_arn" {
  value = aws_s3_bucket.main.arn
}

output "state_bucket_id" {
  value = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}