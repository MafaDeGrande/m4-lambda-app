locals {
  name = "${var.name}-${var.env}"
  tags = {
    Name = var.name
    Env  = var.env
  }
  handler = var.handler
}

resource "aws_lambda_function" "hello_world" {
  function_name = local.name

  s3_bucket = var.s3_bucket
  s3_key = var.s3_key

  runtime = "provided.al2"
  handler = local.handler

  source_code_hash = var.source_code_hash

  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_name 
    }
  }
}

resource "aws_cloudwatch_log_group" "hello_world" { 
  name = "/aws/lambda/${local.name}"
  retention_in_days = 7
}

resource "aws_iam_role" "lambda_exec" {
  name = local.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_polict_for_dynamodb" {
  role = aws_iam_role.lambda_exec.name 
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDynamoDBFullAccess"
}
