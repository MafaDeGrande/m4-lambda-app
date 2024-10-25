output "function_name" {
  description = "Name of the Lambda function."
  value = aws_lambda_function.hello_world.function_name
}

output "arn" {
  description = "Arn identifying Lambda Function"
  value = aws_lambda_function.hello_world.arn
}
