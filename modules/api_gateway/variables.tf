variable "name" {
  type        = string
  description = "Name of the api_gateway"
}

variable "env" {
  type = string
  description = "Name of the environment"
}

variable "function_name" {
  description = "Name of the Lambda function"
  type = string
}

variable "lambda_arn" {
  description = "Arn identifying Lambda Function"
  type = string
}
