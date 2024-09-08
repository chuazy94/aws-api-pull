# terraform/variables.tf

variable "aws_region" {
  description = "AWS region where the Lambda function is deployed"
  type        = string
  default     = "eu-west-2"
}


# API URL for environment variable
variable "currency_api_url" {
  description = "The API URL that the Lambda function will use to pull currency info"
  type        = string
  default     = "https://open.er-api.com/v6/latest/USD" 
}

# API URL for environment variable
variable "university_api_url" {
  description = "The API URL that the Lambda function will use to pull university info"
  type        = string
  default     = "http://universities.hipolabs.com/search?country=" 
}

# Bucket destination for currency json file dump
variable "currency_bucket_destination" {
  description = "Bucket destination for currency json file dump"
  type        = string
  default     = "api-currency-rate-data-bucket" 
}

# Bucket destination for university json file dump
variable "university_bucket_destination" {
  description = "Bucket destination for university json file dump"
  type        = string
  default     = "api-university-bucket" 
}

variable "lambda_handler" {
  description = "The function handler in the Lambda code"
  type        = string
  default     = "main.lambda_handler"
}

variable "university_crawler" {
  description = "The crawler name for university tables"
  type        = string
  default     = "api-university-data-crawler"
}

variable "currency_crawler" {
  description = "The crawler name for currency tables"
  type        = string
  default     = "api-currency-data-crawler"
}

