resource "aws_glue_crawler" "data_crawler" {
    database_name = var.database_name
    name = var.crawler_name
    role = var.glue_role_arn 
    table_prefix = var.glue_table_prefix

    s3_target {
      
        path = var.crawler_s3_path
      
    }
}