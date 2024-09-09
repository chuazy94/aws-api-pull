resource "aws_iam_role" "step_function_role" {
  name = var.step_function_role_name
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "states.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.step_function_role.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_role" {
  role       = aws_iam_role.step_function_role.name
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy" {
  role       = aws_iam_role.step_function_role.name
  policy_arn  = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_policy" "step_function_glue_athena_policy" {
  name = "step_function_glue_athena_policy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
            "athena:StartQueryExecution",
            "athena:StopQueryExecution",
            "athena:BatchGetQueryExecution",
            "athena:GetQueryExecution",
            "athena:GetQueryExecutions",
            "glue:GetTables",
            "glue:GetTable",
            "glue:CreateTable",
            "glue:DeleteTable",
            "glue:UpdateTable",
            "glue:GetDatabase",
            "glue:GetDatabases"
        ]
        Effect   = "Allow",
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "step_function_athena_glue_policy" {
  role       = aws_iam_role.step_function_role.name
  policy_arn  = aws_iam_policy.step_function_glue_athena_policy.arn
}