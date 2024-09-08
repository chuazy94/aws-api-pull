data "archive_file" "lambda_currency_pull_zip" {
  type        = "zip"
  source_dir = "${path.module}/../lambda/currency-api-pull-lambda"
  output_path = "${path.module}/../currency_api_pull_lambda.zip"
}

data "archive_file" "lambda_university_pull_zip" {
  type        = "zip"
  source_dir = "${path.module}/../lambda/university-api-pull-lambda"
  output_path = "${path.module}/../university-api-pull-lambda.zip"
}

data "archive_file" "lambda_invoke_glue_currency_zip" {
  type        = "zip"
  source_dir = "${path.module}/../lambda/invoke-currency-glue-crawler-lambda"
  output_path = "${path.module}/../invoke-currency-glue-crawler-lambda.zip"
}


data "archive_file" "lambda_invoke_glue_university_pull_zip" {
  type        = "zip"
  source_dir = "${path.module}/../lambda/invoke-university-glue-crawler-lambda"
  output_path = "${path.module}/../invoke-university-glue-crawler-lambda.zip"
}


# data "archive_file" "lambda_third_function_zip" {
#   type        = "zip"
#   source_file = "${path.module}/../lambda/third-function.py"
#   output_path = "${path.module}/../third_function.zip"
# }

module "iam" {
  source = "./modules/iam"  
  api_pull_role_name            = "api_pull_lambda_role"
  invoke_crawler_role_name      = "invoke_crawler_lambda_role"
  api_pull_policy_name          = "api_pull_policy"
  invoke_crawler_policy_name    = "invoke_crawler_policy"
  currency_glue_s3_policy_name  = "s3_glue_policy"
}

module "lambda_layer" {
  source = "./modules/lambda/layers"
}

module "currency_api_pull_lambda" {
  source = "./modules/lambda"
  # currency_api_pull_lambda config
  function_name = "currency_api_pull_lambda"
  lambda_runtime = "python3.12"
  zip_file = data.archive_file.lambda_currency_pull_zip.output_path
  role_arn = module.iam.api_pull_role_arn
  lambda_memory_size = var.pull_lambda_memory_size
  lambda_timeout = var.pull_lambda_timeout
  environment_variables = {
    api_url = var.currency_api_url
    bucket_destination = var.currency_bucket_destination
  }
  function_layers = [module.lambda_layer.layer_arn]

}

module "university_api_pull_lambda" {
  source = "./modules/lambda"
  # Lambda 2 config
  function_name = "university_api_pull_lambda"
  lambda_runtime = "python3.12"
  zip_file =  data.archive_file.lambda_university_pull_zip.output_path
  role_arn = module.iam.api_pull_role_arn
  lambda_memory_size = var.pull_lambda_memory_size
  lambda_timeout = var.pull_lambda_timeout
  environment_variables = {
    api_url = var.university_api_url
    bucket_destination = var.university_bucket_destination
  }
  function_layers = [module.lambda_layer.layer_arn]

}

module "university_invoke_glue_lambda" {
  source = "./modules/lambda"
  # Lambda 2 config
  function_name = "invoke_university_glue_lambda"
  lambda_runtime = "python3.12"
  zip_file =  data.archive_file.lambda_invoke_glue_university_pull_zip.output_path
  role_arn = module.iam.invoke_crawler_role_arn
  lambda_memory_size = var.invoke_lambda_memory_size
  lambda_timeout = var.invoke_lambda_timeout
  environment_variables = {
    crawler_name = var.university_crawler
  }
}

module "currency_invoke_glue_lambda" {
  source = "./modules/lambda"
  # Lambda 2 config
  function_name = "invoke_currency_glue_lambda"
  lambda_runtime = "python3.12"
  zip_file =  data.archive_file.lambda_invoke_glue_currency_zip.output_path
  role_arn = module.iam.invoke_crawler_role_arn
  lambda_memory_size = var.invoke_lambda_memory_size
  lambda_timeout = var.invoke_lambda_timeout
  environment_variables = {
    crawler_name = var.currency_crawler
  }
}

module "currency_glue_crawler"{
  source = "./modules/glue"
  crawler_name = "currency-rate-crawler"
  database_name = var.athena_database_name
  glue_role_arn = module.iam.glue_crawler_role_arn
  glue_table_prefix = "raw_"
  crawler_s3_path = var.crawler_currency_s3_path
}

module "university_glue_crawler"{
  source = "./modules/glue"
  crawler_name = "api-university-data-crawler"
  database_name = var.athena_database_name
  glue_role_arn = module.iam.glue_crawler_role_arn
  glue_table_prefix = "raw_"
  crawler_s3_path = var.crawler_university_s3_path
}