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
  lambdas = {
    "api/v1/create" = {
      name = "serverless_lambda_create"
      handler = "create.handler"
      path = "${path.cwd}/todos/create"
      key = "create.zip"
      env = "dev"
      route = "POST /api/v1/create"
    }
    "api/v1/delete" = {
      name = "serverless_lambda_delete"
      handler = "delete.handler"
      path = "${path.cwd}/todos/delete"
      key = "delete.zip"
      env = "dev"
      route = "DELETE /api/v1/delete"
    }
    "api/v1/get" = {
      name = "serverless_lambda_get"
      handler = "get.handler"
      path = "${path.cwd}/todos/get"
      key = "get.zip"
      env = "dev"
      route = "GET /api/v1/get"
    }
    "api/v1/list" = {
      name = "serverless_lambda_list"
      handler = "list.handler"
      path = "${path.cwd}/todos/list"
      key = "list.zip"
      env = "dev"
      route = "GET /api/v1/list"
    }
    "api/v1/update" = {
      name = "serverless_lambda_update"
      handler = "update.handler"
      path = "${path.cwd}/todos/update"
      key = "update.zip"
      env = "dev"
      route = "PUT /api/v1/update"
    }
  }
}

resource "aws_dynamodb_table" "lambdadb_table" {
  name = "lambda_dynamodb_items"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

module "aws_lambda" {
  source = "./modules/lambda"
  for_each = local.lambdas
  name = each.value.name
  handler = each.value.name
  env = each.value.env
  s3_bucket = aws_s3_bucket.lambda_bucket.bucket 
  s3_key = module.s3[each.key].s3_key 
  source_code_hash = module.s3[each.key].source_code_hash
  dynamodb_name = aws_dynamodb_table.lambdadb_table.name
}

module "api_gateway" {
  source = "./modules/api_gateway"
  name = "serverless_http_api"
  env = "dev"
  lambdas = module.aws_lambda
  lambda_params = local.lambdas
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "s3lambda-teach-app-dev"
  force_destroy = true
}

module "s3" {
  source = "./modules/s3/"
  for_each = local.lambdas
  bucket_id = aws_s3_bucket.lambda_bucket.id
  path = each.value.path
  key = each.value.key
}


