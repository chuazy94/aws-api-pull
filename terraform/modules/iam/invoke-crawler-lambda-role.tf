resource "aws_iam_role" "invoke_crawler_role" {
  name = "invoke_crawler_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "invoke_crawler_lambda_role_policy" {
  name = "invoke_crawler_policy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [ "s3:*",
                "s3-object-lambda:*",
                "glue:*",
                "cloudwatch:PutMetricData"]
        Effect   = "Allow",
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "invoke_crawler_lambda_role_policy" {
  role       = aws_iam_role.invoke_crawler_role.name
  policy_arn  = aws_iam_policy.invoke_crawler_lambda_role_policy.arn
}