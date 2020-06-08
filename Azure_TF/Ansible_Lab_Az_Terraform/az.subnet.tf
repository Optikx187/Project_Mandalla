# Create a subnet for Network VMs
resource "azurerm_subnet" "az-net-subnet0" {
  name                 = "${var.app_name}-${var.environment}-subnet"
  address_prefixes       = [var.az-net-subnet0-cidr0]
  virtual_network_name = "${azurerm_virtual_network.az-net-vnet0.name}"
  resource_group_name  = "${azurerm_resource_group.rg0.name}"
}