#create resource group
resource "azurerm_resource_group" "rg0" {
 name     = "${var.app_name}-${var.environment}-rg"
 location = "${var.location}"
 tags = {
 application = "${var.app_name}"
 environment = "${var.environment}"
  }
}