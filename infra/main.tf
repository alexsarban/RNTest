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

resource "azurerm_resource_group" "rn_test_resource_group" {
  name     = "rn-express-api-rg"
  location = "UK South"
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