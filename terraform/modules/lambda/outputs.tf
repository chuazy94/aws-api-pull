# Output Lambda ARN
output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.lambda.arn
}

# Output Lambda Name
output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.lambda.function_name
}

output "lambda_function_runtime" {
  description = "The runtime of the Lambda function"
  value       = aws_lambda_function.lambda.runtime
}

output "lambda_function_handler" {
  description = "The handler of the Lambda function"
  value       = aws_lambda_function.lambda.handler
}

output "lambda_function_role" {
  description = "The IAM role ARN for the Lambda function"
  value       = aws_lambda_function.lambda.role
}

# output "lambda_function_name" {
#   description = "The name of the Lambda function"
#   value       = aws_lambda_function.currency_api_pull_lambda.function_name
# }

# Output Lambda CloudWatch Log Group Name
output "lambda_log_group" {
  description = "The name of the Lambda log group in CloudWatch"
  value       = aws_cloudwatch_log_group.lambda_log_group.name
}

# output "lambda_log_group" {
#   description = "The name of the Lambda log group in CloudWatch"
#   value       = aws_cloudwatch_log_group.lambda_log_group.name
# }

