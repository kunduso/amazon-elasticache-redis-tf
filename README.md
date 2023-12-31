[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-white.svg)](https://choosealicense.com/licenses/unlicense/)[![GitHub pull-requests closed](https://img.shields.io/github/issues-pr-closed/kunduso/amazon-elasticache-redis-tf)](https://github.com/kunduso/amazon-elasticache-redis-tf/pulls?q=is%3Apr+is%3Aclosed)[![GitHub pull-requests](https://img.shields.io/github/issues-pr/kunduso/amazon-elasticache-redis-tf)](https://GitHub.com/kunduso/amazon-elasticache-redis-tf/pull/)
[![GitHub issues-closed](https://img.shields.io/github/issues-closed/kunduso/amazon-elasticache-redis-tf)](https://github.com/kunduso/amazon-elasticache-redis-tf/issues?q=is%3Aissue+is%3Aclosed)[![GitHub issues](https://img.shields.io/github/issues/kunduso/amazon-elasticache-redis-tf)](https://GitHub.com/kunduso/amazon-elasticache-redis-tf/issues/)
[![terraform-infra-provisioning](https://github.com/kunduso/amazon-elasticache-redis-tf/actions/workflows/terraform.yml/badge.svg?branch=main)](https://github.com/kunduso/amazon-elasticache-redis-tf/actions/workflows/terraform.yml)[![checkov-static-analysis-scan](https://github.com/kunduso/amazon-elasticache-redis-tf/actions/workflows/code-scan.yml/badge.svg?branch=main)](https://github.com/kunduso/amazon-elasticache-redis-tf/actions/workflows/code-scan.yml)


![Image](https://skdevops.files.wordpress.com/2023/12/87-image-0-1.png)
# Motivation
Amazon ElastiCache service supports Redis and Memcached. If you want in an in-memory caching solution for your application, check out the [AWS-Docs](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.html). In this repository I cover **two use cases.**

<br />**Use-Case 1:** Create an Amazon ElastiCache for Redis cluster using Terraform, and
<br />**Use-Case 2:** Create an Amazon ElastiCache for Redis cluster and Amazon EC2 instances to access the cluster using Terraform.

<br />If you are interested in Use-case 1, please refer to the [create-amazon-elasticache branch.](https://github.com/kunduso/amazon-elasticache-redis-tf/tree/create-amazon-elasticache)

For Use-case 2, this repository has the Terraform code to provision an Amazon ElastiCache for Redis cluster and all the supporting infrastructure components like Amazon VPC, subnets, security group, AWS KMS key, and AWS Secrets Manager secret. It also has addition AWS cloud resources like:
<br />- an **internet gateway** and update the path in the route table attached to the **public subnet**
<br />- an **IAM instance profile** and attach an **IAM role** with the two existing **IAM policies** to read from the **SSM parameter store** and **AWS Secrets manager**. These resources have the ElastiCache endpoint and auth_token stored that was created in Use-case 1.
<br />- two **Amazon EC2 instances** in the public subnet with separate user data scripts to install **Python libraries** and create Python files inside the instances.
<br />The process of provisioning is automated using **GitHub Actions**.

<br />I discussed the concept in detail in my notes at [-Connect to an Amazon ElastiCache cluster from an Amazon EC2 instance using Python](https://skundunotes.com/2023/12/13/connect-to-an-amazon-elasticache-cluster-from-an-amazon-ec2-instance-using-python/).

<br />I used **Bridgecrew Checkov** to scan the Terraform code for security vulnerabilities. Here is a link if you are interested in adding code scanning capabilities to your GitHub Actions pipeline [-automate-terraform-configuration-scan-with-checkov-and-github-actions](https://skundunotes.com/2023/04/12/automate-terraform-configuration-scan-with-checkov-and-github-actions/).
<br />I also used **Infracost** to generate a cost estimate of building the architecture. If you want to learn more about adding Infracost estimates to your repository, head over to this note [-estimate AWS Cloud resource cost with Infracost, Terraform, and GitHub Actions](https://skundunotes.com/2023/07/17/estimate-aws-cloud-resource-cost-with-infracost-terraform-and-github-actions/).
<br />Lastly, I also automated the process of provisioning the resources using **GitHub Actions** pipeline and I discussed that in detail at [-CI-CD with Terraform and GitHub Actions to deploy to AWS](https://skundunotes.com/2023/03/07/ci-cd-with-terraform-and-github-actions-to-deploy-to-aws/).
## Prerequisites
For this code to function without errors, I created an **OpenID connect** identity provider in **Amazon Identity and Access Management** that has a trust relationship with this GitHub repository. You can read about it [here](https://skundunotes.com/2023/02/28/securely-integrate-aws-credentials-with-github-actions-using-openid-connect/) to get a detailed explanation with steps.
<br />I stored the ARN of the IAM Role as a GitHub secret which is referred in the [`terraform.yml`](https://github.com/kunduso/amazon-elasticache-redis-tf/blob/eb148db2b9ff37cff9f1fb469d0c14b6479bd57a/.github/workflows/terraform.yml#L42) file.
<br />Since I used Infracost in this repository, I stored the `INFRACOST_API_KEY` as a repository secret. It is referenced in the [`terraform.yml`](https://github.com/kunduso/amazon-elasticache-redis-tf/blob/eb148db2b9ff37cff9f1fb469d0c14b6479bd57a/.github/workflows/terraform.yml#L52) GitHub actions workflow file.
<br />As part of the Infracost integration, I also created a `INFRACOST_API_KEY` and stored that as a GitHub Actions secret. I also managed the cost estimate process using a GitHub Actions variable `INFRACOST_SCAN_TYPE` where the value is either `hcl_code` or `tf_plan`, depending on the type of scan desired.
## Usage
Ensure that the policy attached to the IAM role whose credentials are being used in this configuration has permission to create and manage all the resources that are included in this repository.

<br />Review the code including the [`terraform.yml`](./.github/workflows/terraform.yml) to understand the steps in the GitHub Actions pipeline. Also review the terraform code to understand all the concepts associated with creating an AWS VPC, subnets, internet gateway, route table, and route table association.
<br />If you want to check the pipeline logs, click on the **Build Badge** (terrform-infra-provisioning) above the image in this ReadMe.
## License
This code is released under the Unlincse License. See [LICENSE](LICENSE).