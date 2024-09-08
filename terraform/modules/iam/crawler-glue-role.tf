resource "aws_iam_role" "crawler_glue_role" {
  name = "crawler_glue_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "glue.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "glue_service_policy" {
    role = aws_iam_role.crawler_glue_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_s3_policy" {
    name = var.currency_glue_s3_policy_name
    role = aws_iam_role.crawler_glue_role.id
    policy =  jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [ "s3:*",
                "s3-object-lambda:*",
                "glue:*",
                "cloudwatch:PutMetricData",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"]
        Effect   = "Allow",
        Resource = "*"
      },
    ]
  })
}