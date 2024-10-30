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

variable "dynamodb_name" {
  type = string
  description = "dynamodb name"
}

variable "dynamodb_arn" {
  type = string
  description = "dynamodb arn"
}

variable "filename" {
  type = string
  description = "path to the zip file where lambda function is"
}
