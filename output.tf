output "account_id" {
  value = var.databricks_account_id
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "igw" {
  value = module.networking.igw
}

output "nat" {
  value = module.networking.nat
}

output "eip" {
  value = module.networking.eip
}

output "sg_id" {
  value = module.networking.sg_id
}

output "public_subnets_id" {
  value = module.networking.public_subnets_id
}

output "private_subnets_id" {
  value = module.networking.private_subnets_id
}

output "route_table_public" {
  value = module.networking.route_table_public
}

output "workspace_id" {
  value = databricks_mws_workspaces.this.id
}

output "workspace_network_id" {
  value = databricks_mws_networks.this.network_id
}

output "workspace_storage_id" {
  value = databricks_mws_storage_configurations.this.storage_configuration_id
}

output "workspace_credentials_id" {
  value = databricks_mws_credentials.this.credentials_id
}

output "databricks_host" {
  value = databricks_mws_workspaces.this.workspace_url
}
