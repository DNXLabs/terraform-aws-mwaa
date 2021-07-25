data "aws_iam_policy_document" "mwaa_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["airflow.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["airflow-env.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "mwaa_role" {
  name               = "mwaa-executor-${var.environment_name}"
  assume_role_policy = data.aws_iam_policy_document.mwaa_assume_role.json
}

resource "aws_iam_role_policy" "mwaa_policy" {
  name   = "mwaa-executor-policy-${var.environment_name}"
  role   = aws_iam_role.mwaa_role.id
  policy = data.aws_iam_policy_document.mwaa_policy.json
}

data "aws_iam_policy_document" "mwaa_policy" {
  statement {
    effect = "Allow"
    actions = [
      "airflow:PublishMetrics"
    ]
    resources = [
      "arn:aws:airflow:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:environment/${var.environment_name}"
    ]
  }
  statement {
    effect = "Deny"
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.mwaa_content.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.mwaa_content.bucket}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject*",
      "s3:GetBucket*",
      "s3:List*"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.mwaa_content.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.mwaa_content.bucket}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:GetLogRecord",
      "logs:GetLogGroupFields",
      "logs:GetQueryResults"
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:airflow-${var.environment_name}-*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "cloudwatch:PutMetricData"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "glue:UpdateDatabase",
      "glue:DeleteDatabase",
      "glue:CreateTable",
      "glue:CreateDatabase",
      "glue:UpdateTable",
      "glue:DeleteTableVersion",
      "glue:BatchDeleteTableVersion",
      "glue:BatchDeleteTable",
      "glue:DeleteTable",
      "glue:GetTable",
      "glue:GetDatabase",
      "glue:GetPartitions",
      "glue:BatchCreatePartition",
      "glue:BatchDeletePartition"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:SendMessage"
    ]
    resources = [
      "arn:aws:sqs:${data.aws_region.current.name}:*:airflow-celery-*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt"
    ]
    not_resources = [
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
    ]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"

      values = [
        "sqs.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:Describe*",
      "dynamodb:PartiQLSelect",
      "dynamodb:Get*",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:BatchGetItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:List*",
    ]
    resources = [
      "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:*"
    ]
  }

  # Policy to grant acces to SSM
  statement {
    effect = "Allow"
    actions = [
      "ssm:*"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/*"
    ]
  }

  # Policy to grant access to LogEvents
  statement {
    effect = "Allow"
    actions = [
      "logs:*"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"]
  }

  # Policy to grant access to CloudWatch
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"]
  }
}
