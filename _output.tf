output "mwaa_role_arn" {
  value = aws_iam_role.mwaa_role.arn
}

output "mwaa_role_name" {
  value = aws_iam_role.mwaa_role.id
}