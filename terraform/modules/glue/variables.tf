variable "database_name" {
  description = "The name of the database containing the resulting table"
  type        = string
}

variable "crawler_name" {
  description = "The name of the glue crawler"
  type        = string
}

variable "glue_role_arn" {
  description = "The name of the Glue crawler IAM role"
  type        = string
}

variable "glue_table_prefix" {
  description = "The prefix to the glue table"
  type        = string
}

variable "crawler_s3_path" {
  description = "The path of the s3 to crawl through"
  type        = string
}