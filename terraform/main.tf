data "archive_file" "lambda_currency_pull_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/currency-api-pull-lambda.py"
  output_path = "${path.module}/../currency_api_pull_lambda.zip"
}

data "archive_file" "lambda_university_pull_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/university-api-pull-lambda.py"
  output_path = "${path.module}/../university-api-pull-lambda.zip"
}

data "archive_file" "lambda_invoke_glue_currency_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/invoke-currency-glue-crawler-lambda.py"
  output_path = "${path.module}/../invoke-currency-glue-crawler-lambda.zip"
}


data "archive_file" "lambda_invoke_glue_university_pull_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/invoke-university-glue-crawler-lambda.py"
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
  environment_variables = {
    crawler_name = var.currency_crawler
  }
}

#   # Lambda 3 config
#   lambda_3_name               = "lambda-function-3"
#   lambda_3_handler            = "app.lambda_handler"
#   lambda_3_runtime            = "python3.9"
#   lambda_3_zip_file           = "../lambda_functions/function3/deployment.zip"
#   lambda_3_environment_variables = {
#     VAR3 = "value3"
#   }
