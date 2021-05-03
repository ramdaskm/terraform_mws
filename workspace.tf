resource "databricks_mws_workspaces" "this" {
  provider        = databricks.mws
  account_id      = var.databricks_account_id
  aws_region      = local.region
  workspace_name  = local.prefix
  deployment_name = local.url
  is_no_public_ip_enabled = true
  network_id               = databricks_mws_networks.this.network_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
  credentials_id           = databricks_mws_credentials.this.credentials_id
}


