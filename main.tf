terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.37"
    }
  }
  backend "s3" {
    bucket         = "s3dumb-frontend-host-terraform-state-dynamodb"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "s3dumb-frontend-host-running-locks"
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  env = "dev"
  lambda_key = "/api/v1/"
  lambda_name = "serverless-lambda"
  lambdas = {
    "api/v1/create" = {
      name = "${local.lambda_name}create"
      handler = "create.handler"
      path = "${path.cwd}/todos/create"
      key = "create.zip"
      route = "POST ${local.lambda_key}create"
    }
    "api/v1/delete" = {
      name = "${local.lambda_name}-delete"
      handler = "delete.handler"
      path = "${path.cwd}/todos/delete"
      key = "delete.zip"
      route = "DELETE ${local.lambda_key}delete"
    }
    "api/v1/get" = {
      name = "${local.lambda_name}-get"
      handler = "get.handler"
      path = "${path.cwd}/todos/get"
      key = "get.zip"
      route = "GET ${local.lambda_key}get"
    }
    "api/v1/list" = {
      name = "${local.lambda_name}-list"
      handler = "list.handler"
      path = "${path.cwd}/todos/list"
      key = "list.zip"
      route = "GET ${local.lambda_key}list"
    }
    "api/v1/update" = {
      name = "${local.lambda_name}-update"
      handler = "update.handler"
      path = "${path.cwd}/todos/update"
      key = "update.zip"
      route = "PUT ${local.lambda_key}update"
    }
  }
}

module "dynamodb" {
  source = "./modules/dynamodb/"
  name = "${local.lambda_name}-dynamodb"
}

module "aws_lambda" {
  source = "./modules/lambda"
  for_each = local.lambdas
  name = each.value.name
  handler = each.value.name
  filename = "${each.value.path}/${each.value.key}"
  env = local.env
  dynamodb_name = module.dynamodb.dynamodb_name
  dynamodb_arn = module.dynamodb.dynamodb_arn
}

module "api_gateway" {
  source = "./modules/api_gateway"
  name = "${local.lambda_name}-http-api"
  env = local.env
  lambdas = module.aws_lambda
  lambda_params = local.lambdas
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "s3lambda-teach-app-dev"
  force_destroy = true
}
