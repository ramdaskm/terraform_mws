
data "databricks_aws_assume_role_policy" "this" {
  external_id = var.databricks_account_id
}

//we use databricks provided IAM. This block is not needed
/*
resource "aws_iam_role" "cross_account_role" {
  name               = "${local.prefix}-crossaccount"
  assume_role_policy = data.databricks_aws_assume_role_policy.this.json
  tags               = var.a_tags
}


data "databricks_aws_crossaccount_policy" "this" {
}

resource "aws_iam_role_policy" "this" {
  name   = "${local.prefix}-policy"
  role   = aws_iam_role.cross_account_role.id
  policy = data.databricks_aws_crossaccount_policy.this.json
}
*/

resource "databricks_mws_credentials" "this" {
  provider         = databricks.mws
  account_id       = var.databricks_account_id
  role_arn         = local.iamrole
  credentials_name = "${local.prefix}-creds"
  //depends_on       = [aws_iam_role_policy.this]
}