# Amazon MWAA constraints
#  - S3 bucket needs to start with prefix "airflow"
#  - Mandatory to set Block Public Access
resource "aws_s3_bucket" "mwaa_content" {
  bucket = "mwaa-${var.org_name}-${var.environment_name}-${data.aws_region.current.name}"
}

resource "aws_s3_bucket_acl" "mwaa_content" {
  bucket = aws_s3_bucket.mwaa_content.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "mwaa_content" {
  bucket = aws_s3_bucket.mwaa_content.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "mwaa_public_access_block" {
  bucket = aws_s3_bucket.mwaa_content.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_object" "plugins" {
  key    = "plugins.zip"
  bucket = aws_s3_bucket.mwaa_content.id
}

resource "aws_s3_bucket_object" "python_requirements" {
  key    = "requirements.txt"
  bucket = aws_s3_bucket.mwaa_content.id
}