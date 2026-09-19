# ================================================================
# Remote State — Read Project 1 (Landing Zone) outputs
# ================================================================
data "terraform_remote_state" "lz" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstaterajim01"
    container_name       = "tfstate"
    key                  = "landing-zone.tfstate"
  }
}

# ================================================================
# Local values — pull relevant LZ outputs
# ================================================================
locals {
  lz = data.terraform_remote_state.lz.outputs

  # Subnet IDs
  app_subnet_id  = local.lz.spoke_app_subnet_ids["app"]
  pe_subnet_id   = local.lz.spoke_data_subnet_ids["pe"]
  data_subnet_id = local.lz.spoke_data_subnet_ids["data"]

  # Resource Group Names
  spoke_app_rg_name  = local.lz.spoke_app_resource_group_name
  spoke_data_rg_name = local.lz.resource_group_names["spoke_data"]
  hub_rg_name        = local.lz.hub_resource_group_name

  # Monitoring & DNS
  law_id               = local.lz.log_analytics_workspace_id
  private_dns_zone_ids = local.lz.private_dns_zone_ids

  # Hub & Firewall
  hub_vnet_id         = local.lz.hub_vnet_id
  firewall_private_ip = local.lz.firewall_private_ip

  prefix = "mta"
}