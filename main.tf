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

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.prefix}}-servers"
  location = "westus2"
}

resource "azurerm_network_interface" "nic" {
  name                = "identity01-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                          = "ipconfig"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.tfe_outputs.ws-mgmt.values.identity_snet_id
  }
}
