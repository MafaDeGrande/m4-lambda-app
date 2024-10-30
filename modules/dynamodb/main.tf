resource "aws_dynamodb_table" "lambdadb_table" {
  name = "lambda_dynamodb_items"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

