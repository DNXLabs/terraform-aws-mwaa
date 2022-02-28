resource "aws_ssm_parameter" "mwaa_env" {
  name        = "/mwaa/ENV"
  description = "MWAA Environment"
  value       = var.environment_name
  type        = "String"
}