resource "aws_mwaa_environment" "mwaa" {
  name              = var.environment_name
  airflow_version   = var.airflow_version
  environment_class = var.environment_class
  min_workers       = var.min_workers
  max_workers       = var.max_workers

  execution_role_arn = aws_iam_role.mwaa_role.arn

  airflow_configuration_options = {
    # DAG timeout and log level
    "core.dagbag_import_timeout" = var.airflow_configuration_options["dag_timeout"]
    "logging.logging_level"      = var.airflow_configuration_options["log_level"]
    "core.default_task_retries"  = var.airflow_configuration_options["core.default_task_retries"]
    "celery.worker_autoscale"    = var.airflow_configuration_options["celery.worker_autoscale"]

    # Airflow webserver timeout
    "webserver.web_server_master_timeout" = var.airflow_configuration_options["webserver_timeout"]["master"]
    "webserver.web_server_worker_timeout" = var.airflow_configuration_options["webserver_timeout"]["worker"]
  }

  logging_configuration {
    dag_processing_logs {
      enabled   = var.logging_configuration["dag_processing_logs"]["enabled"]
      log_level = var.logging_configuration["dag_processing_logs"]["log_level"]
    }

    scheduler_logs {
      enabled   = var.logging_configuration["scheduler_logs"]["enabled"]
      log_level = var.logging_configuration["scheduler_logs"]["log_level"]
    }

    task_logs {
      enabled   = var.logging_configuration["task_logs"]["enabled"]
      log_level = var.logging_configuration["task_logs"]["log_level"]
    }

    webserver_logs {
      enabled   = var.logging_configuration["webserver_logs"]["enabled"]
      log_level = var.logging_configuration["webserver_logs"]["log_level"]
    }

    worker_logs {
      enabled   = var.logging_configuration["worker_logs"]["enabled"]
      log_level = var.logging_configuration["worker_logs"]["log_level"]
    }
  }

  dag_s3_path          = var.dag_s3_path
  plugins_s3_path      = var.plugins_s3_path
  requirements_s3_path = var.requirements_s3_path

  network_configuration {
    security_group_ids = [aws_security_group.mwaa_sg.id]
    subnet_ids         = var.private_subnet_ids
  }

  lifecycle {
    ignore_changes = [
      plugins_s3_object_version,
      requirements_s3_object_version
    ]
  }

  source_bucket_arn = aws_s3_bucket.mwaa_content.arn
}