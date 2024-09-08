resource "aws_sfn_state_machine" "step_function" {
  name     = var.step_function_name
  role_arn = var.step_function_role_arn
  definition = file("${path.module}/state_machine_definition.json")
}