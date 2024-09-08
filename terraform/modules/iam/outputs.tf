output "api_pull_role_arn" {
  description = "The ARN of the API pull IAM role"
  value       = aws_iam_role.api_pull_lambda_role.arn
}

output "invoke_crawler_role_arn" {
  description = "The ARN of the Invoke Crawler IAM role"
  value       = aws_iam_role.invoke_crawler_role.arn
}

output "glue_crawler_role_arn" {
  description = "The ARN of the glue crawler IAM role"
  value = aws_iam_role.crawler_glue_role.arn
}

output "step_function_role_arn" {
  description = "The ARN of the glue crawler IAM role"
  value = aws_iam_role.step_function_role.arn
}