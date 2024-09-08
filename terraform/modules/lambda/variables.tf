# terraform/variables.tf
# Lambda Function Name
variable "function_name" {
  description = "The name of Lambda function"
  type        = string
}


# Lambda Handler
variable "lambda_handler" {
  description = "The function handler in the Lambda code"
  type        = string
  default     = "main.lambda_handler"
}

# Lambda Runtime
variable "lambda_runtime" {
  description = "The Lambda runtime environment"
  type        = string
  default     = "python3.12"
}

variable "zip_file" {
  description = "The deployment package for the Lambda function"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

# Log retention for CloudWatch
variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 7
}

variable "aws_region" {
  description = "AWS region where the Lambda function is deployed"
  type        = string
  default     = "eu-west-2"
}

variable "role_arn"{
      description = "The ARN of the IAM role that Lambda assumes when it executes the function"
  type        = string
}

variable "function_layers" {
  description = "List of Lambda layer ARNs to attach to the function"
  type        = list(string)
  default     = []
}
