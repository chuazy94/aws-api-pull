resource "aws_iam_role" "api_pull_lambda_role" {
  name = "api_pull_lambda_role"

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

resource "aws_iam_policy" "api_pull_lambda_role" {
  name = "api_pull_lambda_policy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
       {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        },
         {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_lambda_role_policy" {
  role       = aws_iam_role.api_pull_lambda_role.name
  policy_arn  = aws_iam_policy.api_pull_lambda_role.arn
}