variable "api_pull_role_name" {
  description = "The name of the API pull IAM role"
  type        = string
}

variable "invoke_crawler_role_name" {
  description = "The name of the Invoke Crawler IAM role"
  type        = string
}

variable "api_pull_policy_name" {
  description = "The name of the API pull policy"
  type        = string
}

variable "invoke_crawler_policy_name" {
  description = "The name of the Invoke Crawler policy"
  type        = string
}