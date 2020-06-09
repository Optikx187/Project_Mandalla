#NSG for Linux and windows vm's
resource "azurerm_network_security_group" "net-sec-grp0" {
    name                = "${var.app_name}-${var.environment}-nsg"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg0.name}"
    tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"
    }
}
#Security Rules
#ssh
resource "azurerm_network_security_rule" "ssh" {
  name = "ssh_from_pip"
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "22"
  source_address_prefix = "*"
  #source_address_prefix = "${var.source_address}"
  destination_address_prefix = "*"
  resource_group_name = "${azurerm_resource_group.rg0.name}"
  network_security_group_name = "${azurerm_network_security_group.net-sec-grp0.name}"
}
#RDP
resource "azurerm_network_security_rule" "RDP" {
  name = "rdp_from_pip"
  priority = 101
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "3389"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = "${azurerm_resource_group.rg0.name}"
  network_security_group_name = "${azurerm_network_security_group.net-sec-grp0.name}"
}
#winrm
resource "azurerm_network_security_rule" "winrm1" {
  name = "winrm1"
  priority = 102
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "*"
  destination_port_range = "47001"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = "${azurerm_resource_group.rg0.name}"
  network_security_group_name = "${azurerm_network_security_group.net-sec-grp0.name}"
}
resource "azurerm_network_security_rule" "winrm2" {
  name = "winrm2"
  priority = 103
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "*"
  destination_port_range = "5985"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = "${azurerm_resource_group.rg0.name}"
  network_security_group_name = "${azurerm_network_security_group.net-sec-grp0.name}"
}
resource "azurerm_network_security_rule" "winrm3" {
  name = "winrm3"
  priority = 104
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "*"
  destination_port_range = "5986"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = "${azurerm_resource_group.rg0.name}"
  network_security_group_name = "${azurerm_network_security_group.net-sec-grp0.name}"
}