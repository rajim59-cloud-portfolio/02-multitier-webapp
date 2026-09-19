provider "azurerm" {
  subscription_id = var.subscription_id

  features {
    # Key Vault: purge on destroy so soft-deleted vaults don't accumulate
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }

    # Resource Group: allow deletion even with resources (clean destroy)
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

    # App Service: clean up on destroy
    app_configuration {
      purge_soft_delete_on_destroy = true
    }
  }
}