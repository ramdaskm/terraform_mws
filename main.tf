/**
 * Databricks E2 workspace with BYOVPC
 *
 * ![preview](./arch.png)
 *
 * Creates AWS IAM cross-account role, AWS S3 root bucket, VPC with Internet gateway, NAT, routing, one public subnet,
 * two private subnets in two different regions. Then it ties all together and creates an E2 workspace.
 */

variable "databricks_account_username" {
}
variable "databricks_account_password" {
}
variable "databricks_account_id" {
}


locals {
  prefix = "overwatch-1" #always use a name like word-number
  cidr_block = "10.177.0.0/16"
  public_subnets_cidr = "${[cidrsubnet(local.cidr_block, 4, 0)]}" #do not change if you want to reuse
  private_subnets_cidr = "${[cidrsubnet(local.cidr_block, 4, 1), cidrsubnet(local.cidr_block, 4, 2)]}"
  region = "us-west-2"
  iamrole = "arn:aws:iam::997819123407:role/rkm-overrole-1"
  common_tags = {
    "Owner"       : "ramdas.murali@databricks.com"
    "Mech"        : "Terraform"
  }
  url = local.prefix
}

locals {
  common_prefix = element(regex("(\\w+)-(\\w+)", local.prefix),0)
}


provider "aws" {
  region = local.region
}

// initialize provider in "MWS" mode to provision new workspace
provider "databricks" {
  alias    = "mws"
  host     = "https://accounts.cloud.databricks.com"
  username = var.databricks_account_username
  password = var.databricks_account_password
}

