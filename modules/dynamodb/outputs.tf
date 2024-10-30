output "dynamodb_arn" {
  description = "dynamodb arn"
  value = aws_dynamodb_table.lambdadb_table.arn 
}

output "dynamodb_name" {
  description = "dynamodb name"
  value = aws_dynamodb_table.lambdadb_table.name
}
