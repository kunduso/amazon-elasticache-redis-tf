[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-white.svg)](https://choosealicense.com/licenses/unlicense/)[![GitHub pull-requests closed](https://img.shields.io/github/issues-pr-closed/kunduso/amazon-elasticache-redis-tf)](https://github.com/kunduso/amazon-elasticache-redis-tf/pulls?q=is%3Apr+is%3Aclosed)[![GitHub pull-requests](https://img.shields.io/github/issues-pr/kunduso/amazon-elasticache-redis-tf)](https://GitHub.com/kunduso/amazon-elasticache-redis-tf/pull/)
[![GitHub issues-closed](https://img.shields.io/github/issues-closed/kunduso/amazon-elasticache-redis-tf)](https://github.com/kunduso/amazon-elasticache-redis-tf/issues?q=is%3Aissue+is%3Aclosed)[![GitHub issues](https://img.shields.io/github/issues/kunduso/amazon-elasticache-redis-tf)](https://GitHub.com/kunduso/amazon-elasticache-redis-tf/issues/)
[![terraform-infra-provisioning](https://github.com/kunduso/amazon-elasticache-redis-tf/actions/workflows/terraform.yml/badge.svg?branch=main)](https://github.com/kunduso/amazon-elasticache-redis-tf/actions/workflows/terraform.yml)[![checkov-static-analysis-scan](https://github.com/kunduso/amazon-elasticache-redis-tf/actions/workflows/code-scan.yml/badge.svg?branch=main)](https://github.com/kunduso/amazon-elasticache-redis-tf/actions/workflows/code-scan.yml) [![Generate terraform docs](https://github.com/kunduso/amazon-elasticache-redis-tf/actions/workflows/documentation.yml/badge.svg)](https://github.com/kunduso/amazon-elasticache-redis-tf/actions/workflows/documentation.yml)


![Image](https://skdevops.files.wordpress.com/2023/10/85-image-0-1.png)
# Motivation
Amazon ElastiCache service supports Redis and Memcached. If you want in an in-memory caching solution for your application, check out the [AWS-Docs](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.html). In this repository I have the Terraform code to provision an Amazon ElastiCache for Redis cluster and all the supporting infrastructure components like Amazon VPC, subnets, security group, AWS KMS key, and AWS Secrets Manager secret.
<br />The process of provisioning is automated using GitHub Actions. I also followed a few best practices while creating the Amazon ElastiCache service, like enabling multi-availability zone, multi-node, and encryption in transit and at rest.

<br />I discussed the concept in detail in my notes at [-create-an-amazon-elasticache-for-redis-cluster-using-terraform](https://skundunotes.com/2023/10/21/create-an-amazon-elasticache-for-redis-cluster-using-terraform/).

<br />I used Bridgecrew Checkov to scan the Terraform code for security vulnerabilities. Here is a link if you are interested in adding code scanning capabilities to your GitHub Actions pipeline [-automate-terraform-configuration-scan-with-checkov-and-github-actions](https://skundunotes.com/2023/04/12/automate-terraform-configuration-scan-with-checkov-and-github-actions/).
<br />I also used Infracost to generate a cost estimate of building the architecture. If you want to learn more about adding Infracost estimates to your repository, head over to this note [-estimate AWS Cloud resource cost with Infracost, Terraform, and GitHub Actions](https://skundunotes.com/2023/07/17/estimate-aws-cloud-resource-cost-with-infracost-terraform-and-github-actions/).
<br />Lastly, I also automated the process of provisioning the resources using GitHub Actions pipeline and I discussed that in detail at [-CI-CD with Terraform and GitHub Actions to deploy to AWS](https://skundunotes.com/2023/03/07/ci-cd-with-terraform-and-github-actions-to-deploy-to-aws/).
## Prerequisites
For this code to function without errors, I created an OpenID connect identity provider in Amazon Identity and Access Management that has a trust relationship with this GitHub repository. You can read about it [here](https://skundunotes.com/2023/02/28/securely-integrate-aws-credentials-with-github-actions-using-openid-connect/) to get a detailed explanation with steps.
<br />I stored the ARN of the IAM Role as a GitHub secret which is referred in the [`terraform.yml`](https://github.com/kunduso/amazon-elasticache-redis-tf/blob/eb148db2b9ff37cff9f1fb469d0c14b6479bd57a/.github/workflows/terraform.yml#L42) file.
<br />Since I used Infracost in this repository, I stored the `INFRACOST_API_KEY` as a repository secret. It is referenced in the [`terraform.yml`](https://github.com/kunduso/amazon-elasticache-redis-tf/blob/eb148db2b9ff37cff9f1fb469d0c14b6479bd57a/.github/workflows/terraform.yml#L52) GitHub actions workflow file.
<br />As part of the Infracost integration, I also created a `INFRACOST_API_KEY` and stored that as a GitHub Actions secret. I also managed the cost estimate process using a GitHub Actions variable `INFRACOST_SCAN_TYPE` where the value is either `hcl_code` or `tf_plan`, depending on the type of scan desired.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.20.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.20.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | github.com/kunduso/terraform-aws-vpc | v1.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.engine_log](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.slow_log](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_replication_group.app4](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.elasticache_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.secret_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ssm_parameter_policy](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/iam_policy) | resource |
| [aws_kms_alias.encryption_rest](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/kms_alias) | resource |
| [aws_kms_alias.encryption_secret](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/kms_alias) | resource |
| [aws_kms_key.encryption_rest](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/kms_key) | resource |
| [aws_kms_key.encryption_secret](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.encryption_rest_policy](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/kms_key_policy) | resource |
| [aws_kms_key_policy.encryption_secret_policy](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/kms_key_policy) | resource |
| [aws_secretsmanager_secret.elasticache_auth](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.auth](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.elasticache](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/security_group) | resource |
| [aws_security_group_rule.elasticache_egress](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elasticache_ingress](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.elasticache_ep](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.elasticache_port](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/resources/ssm_parameter) | resource |
| [random_password.auth](https://registry.terraform.io/providers/hashicorp/random/3.6.3/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.20.1/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | The access\_key that belongs to the IAM user. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the application. | `string` | `"app-4"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Cloud infrastructure region. | `string` | `"us-east-2"` | no |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | The secret\_key that belongs to the IAM user. | `string` | `""` | no |
| <a name="input_subnet_cidr_private"></a> [subnet\_cidr\_private](#input\_subnet\_cidr\_private) | CIDR blocks for the private subnets. | `list(any)` | <pre>[<br/>  "10.20.32.0/27",<br/>  "10.20.32.32/27",<br/>  "10.20.32.64/27"<br/>]</pre> | no |
| <a name="input_subnet_cidr_public"></a> [subnet\_cidr\_public](#input\_subnet\_cidr\_public) | CIDR blocks for the public subnets. | `list(any)` | <pre>[<br/>  "10.20.32.96/27"<br/>]</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR for the VPC. | `string` | `"10.20.32.0/25"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
## Usage
Ensure that the policy attached to the IAM role whose credentials are being used in this configuration has permission to create and manage all the resources that are included in this repository.

<br />Review the code including the [`terraform.yml`](./.github/workflows/terraform.yml) to understand the steps in the GitHub Actions pipeline. Also review the terraform code to understand all the concepts associated with creating an AWS VPC, subnets, internet gateway, route table, and route table association.
<br />If you want to check the pipeline logs, click on the **Build Badge** (terrform-infra-provisioning) above the image in this ReadMe.
## Contributing
If you find any issues or have suggestions for improvement, feel free to open an issue or submit a pull request. Contributions are always welcome!
## License
This code is released under the Unlincse License. See [LICENSE](LICENSE).