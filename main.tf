locals {
  prefix   = "jbt-${var.environment}-${var.tags["location"]}"
  location = var.tags["location"]
  tags     = merge(var.tags)
}

data "azurerm_client_config" "config" {}

data "tfe_outputs" "ws-mgmt" {
  organization = "jbt-terraform-learning"
  workspace    = "jbt-workspace-mgmt"
}

resource "azurerm_resource_group" "rg-identity" {
  name     = "rg-${local.prefix}}-identity"
  location = "westus2"
}

resource "azurerm_resource_group" "rg-app1" {
  name     = "rg-${local.prefix}}-app1"
  location = "westus2"
}

resource "azurerm_network_interface" "identity01-nic" {
  name                = "identity01-nic"
  resource_group_name = azurerm_resource_group.rg-identity.name
  location            = azurerm_resource_group.rg-identity.location
  ip_configuration {
    name                          = "ipconfig"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.tfe_outputs.ws-mgmt.values.identity_snet_id
  }
}


# To Do: create VM

resource "azurerm_network_interface" "app1-01-nic" {
  name                = "app1-01-nic"
  resource_group_name = azurerm_resource_group.rg-app1.name
  location            = azurerm_resource_group.rg-app1.location
  ip_configuration {
    name                          = "ipconfig"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.tfe_outputs.ws-mgmt.values.app1_snet_id
  }
}