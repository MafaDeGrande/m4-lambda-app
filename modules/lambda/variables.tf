variable "name" {
  type        = string
  description = "Name of the aws lamda"
}

variable "env" {
  type = string
  description = "Name of the environment"
}

variable "handler" {
  type = string
  description = "Function entrypoint in code"
}

variable "s3_bucket" {
  type = string
  description = "S3 bucket location containing the function's deployment package"
}

variable "s3_key" {
  type = string
  description = "S3 key of an object containing the function's deployment package"
}

variable "source_code_hash" {
  type = string
  description = "Virtual attribute used to trigger replacement when source code changes"
}

variable "dynamodb_name" {
  type = string
  description = "dynamodb name"
}
