provider "aws" {
  region = "us-east-1"
}

resource "random_id" "bucket_id" {
  byte_length = 8
}

module "s3" {
  source         = "./modules/s3"
  bucket_name    = "todo-app-bucket-${random_id.bucket_id.hex}"
  lambda_role_arn = module.iam.lambda_role_arn
}

module "iam" {
  source        = "./modules/iam"
  role_name     = "todo_lambda_role"
  s3_bucket_arn = module.s3.bucket_arn
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  api_name          = "todo-api"
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}

module "lambda" {
  source                     = "./modules/lambda"
  function_name              = var.lambda_function_name
  role_arn                   = module.iam.lambda_role_arn
  handler                    = var.lambda_handler
  runtime                    = var.lambda_runtime
  source_dir                 = "${path.module}/../dist"
  s3_bucket_name             = module.s3.bucket_id
  api_gateway_execution_arn  = module.api_gateway.execution_arn
}