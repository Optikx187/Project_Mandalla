#create vnet
resource "azurerm_virtual_network" "az-net-vnet0" {
 name = "${var.app_name}-${var.environment}-vnet"
 address_space = ["${var.az-net-vnet0-cidr0}"]
 resource_group_name = "${azurerm_resource_group.rg0.name}"
 location = "${var.location}"
 tags = {
    application = "${var.app_name}"
    environment = "${var.environment}"
  }
}