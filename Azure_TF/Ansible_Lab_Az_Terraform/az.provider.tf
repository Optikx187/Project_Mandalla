provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being u$  version = "=2.5.0"
  version         ="~>2.0"
  client_id       ="${var.client_id}"
  client_secret   ="${var.client_secret}"
  subscription_id ="${var.subscription_id}"
  tenant_id       ="${var.tenant_id}"

features {}
}






