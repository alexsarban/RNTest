terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rn_test_storage_rg" {
  name     = "rn-test-storage-rg"
  location = "UK South"
}

#terraform state file resources for remote state (rg, storage account and blob)
resource "azurerm_resource_group" "rn_test_resource_group" {
  name     = "rn-express-api-rg"
  location = "UK South"
}

resource "azurerm_storage_account" "rn_test_storage_account" {
  name                     = "rnteststorage123" # Must be globally unique
  resource_group_name      = azurerm_resource_group.rn_test_storage_rg.name
  location                 = azurerm_resource_group.rn_test_storage_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "rn_test_storage_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.rn_test_storage_account.name
  container_access_type = "private"
}

# backend config to to use the storage and blob container created above (note there will be no terraform state file in it)
terraform {
  backend "azurerm" {
    resource_group_name  = azurerm_resource_group.rn_test_storage_rg.name
    storage_account_name = azurerm_storage_account.rn_test_storage_account.name
    container_name       = azurerm_storage_container.rn_test_storage_container.name
    key                  = "rn-express-api.tfstate"
  }
}

resource "azurerm_app_service_plan" "rn_test_app_service_plan" {
  name                = "rn-express-api-plan"
  location            = azurerm_resource_group.rn_test_resource_group.location
  resource_group_name = azurerm_resource_group.rn_test_resource_group.name
  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "rn_test_app_service" {
  name                = "rn-express-api-app"
  location            = azurerm_resource_group.rn_test_resource_group.location
  resource_group_name = azurerm_resource_group.rn_test_resource_group.name
  app_service_plan_id = azurerm_app_service_plan.rn_test_app_service_plan.id
}

output "api_url" {
  value = "https://${azurerm_app_service.rn_test_app_service.default_site_hostname}/api/hello"
}
