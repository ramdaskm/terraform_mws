data "aws_availability_zones" "available" {}


module "networking" {
  source = "./modules/networking"
  prefix               = local.prefix
  common_prefix        = local.common_prefix
  vpc_cidr             = local.cidr_block
  public_subnets_cidr  = local.public_subnets_cidr
  private_subnets_cidr = local.private_subnets_cidr
  region               = local.region
  tags = local.common_tags
  availability_zones   = data.aws_availability_zones.available.names

}


resource "databricks_mws_networks" "this" {
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  network_name       = "${local.prefix}-network"
  security_group_ids = [module.networking.sg_id]
  subnet_ids         = module.networking.private_subnets_id
  vpc_id             = module.networking.vpc_id
}