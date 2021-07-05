# terraform-aws-template

[![Lint Status](https://github.com/DNXLabs/terraform-aws-template/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-template/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-template)](https://github.com/DNXLabs/terraform-aws-template/blob/master/LICENSE)

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| airflow\_configuration\_options | The airflow\_configuration\_options parameter specifies airflow override options. | `any` | n/a | yes |
| airflow\_version | Airflow version of the MWAA environment | `any` | n/a | yes |
| dag\_s3\_path | The relative path to the DAG folder on your Amazon S3 storage bucket. | `string` | `"dags"` | no |
| environment\_class | Environment class for the cluster. Possible options are mw1.small, mw1.medium, mw1.large. | `any` | n/a | yes |
| environment\_name | Name of MWAA Environment | `any` | n/a | yes |
| logging\_configuration | The Apache Airflow logs you want to send to Amazon CloudWatch Logs. | `any` | n/a | yes |
| max\_workers | The maximum number of workers that can be automatically scaled up. Value need to be between 1 and 25. Will be 10 by default. | `number` | `10` | no |
| min\_workers | The minimum number of workers that you want to run in your environment. Will be 1 by default. | `number` | `1` | no |
| plugins\_s3\_path | The relative path to the plugins.zip file on your Amazon S3 storage bucket. For example, plugins.zip. | `string` | `"plugins.zip"` | no |
| private\_subnet\_ids | The private subnet IDs in which the environment should be created. MWAA requires two subnets. | `list(string)` | n/a | yes |
| requirements\_s3\_path | The relative path to the requirements.txt file on your Amazon S3 storage bucket. For example, requirements.txt. | `string` | `"requirements.txt"` | no |
| vpc\_id | VPC ID to deploy the MWAA Environment. | `any` | n/a | yes |
| vpn\_cidr | VPN CIDR Access for Airflow UI | `any` | n/a | yes |

## Outputs

No output.

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-template/blob/master/LICENSE) for full details.