# terraform/lambda.tf

# Currency API Pull lambda


resource "aws_lambda_function" "lambda" {
  filename         = var.zip_file  # Use the archived zip file created dynamically
  function_name    = var.function_name                  # Lambda function name
  handler          = var.lambda_handler                        # Lambda handler (e.g. main.lambda_handler)
  source_code_hash = filebase64sha256(var.zip_file) # Ensures Lambda redeploys if code changes
  runtime          = var.lambda_runtime                        # Runtime (e.g. python3.9)
  role             = var.role_arn             # IAM Role for execution

  # Adding environment variables for the Lambda function
  environment {
    variables = var.environment_variables
    }
  layers = var.function_layers
}



resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 7  # You can adjust retention period as necessary
}

# resource "aws_iam_role" "lambda_exec" {
#   name = "lambda_execution_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = "sts:AssumeRole",
#       Effect = "Allow",
#       Principal = {
#         Service = "lambda.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_policy" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }



# resource "aws_iam_role_policy_attachment" "invoke_glue_lambda_role_policy" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn  = aws_iam_policy.lambda_policy_2.arn
# }