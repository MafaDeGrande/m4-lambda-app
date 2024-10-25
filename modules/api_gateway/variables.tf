variable "name" {
  type        = string
  description = "Name of the api_gateway"
}

variable "env" {
  type = string
  description = "Name of the environment"
}

variable "lambdas" {
  description = "Map for the name of lambda functions and their arns"
  type = map(object({
    arn = string
    function_name = string
  }))
}

variable "lambda_params" {
  description = "Map for the locals of lambda functions"
  type = map(object({
    name = string
    handler = string
    path = string
    key = string
    env = string
    route = string
  }))
}
