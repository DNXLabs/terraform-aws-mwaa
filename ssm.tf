resource "aws_ssm_parameter" "mwaa_env" {
  #   count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/mwaa/ENV"
  description = "MWAA Environment"
  value       = var.environment_name
  type        = "String"
}