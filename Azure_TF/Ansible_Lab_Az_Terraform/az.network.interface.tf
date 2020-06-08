#Create virtual network interface card linux 1
resource "azurerm_network_interface" "net-interface0" {
    name                        = "${var.app_name}-${var.environment}-nic"
    location                    = "${var.location}"
    resource_group_name         = "${azurerm_resource_group.rg0.name}"
    ip_configuration {
        name                          = "${var.app_name}-${var.environment}-nicconfig0"
        subnet_id                     = "${azurerm_subnet.az-net-subnet0.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.az-net-publicip0.id}"
    }
    tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"
    }
}
#Create virtual network interface card windows 1
resource "azurerm_network_interface" "net-interface1" {
    name                        = "${var.app_name}-${var.environment}-nic1"
    location                    = "${var.location}"
    resource_group_name         = "${azurerm_resource_group.rg0.name}"
    ip_configuration {
        name                          = "${var.app_name}-${var.environment}-nicconfig1"
        subnet_id                     = "${azurerm_subnet.az-net-subnet0.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.az-net-publicip1.id}"
    }
    tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"
    }
}
# Connect the security group to the network interface linux 1
resource "azurerm_network_interface_security_group_association" "sec-grp-to-net-int0" {
    network_interface_id      = "${azurerm_network_interface.net-interface0.id}"
    network_security_group_id = "${azurerm_network_security_group.net-sec-grp0.id}"
}
# Connect the security group to the network interface windows 1
resource "azurerm_network_interface_security_group_association" "sec-grp-to-net-int1" {
    network_interface_id      = "${azurerm_network_interface.net-interface1.id}"
    network_security_group_id = "${azurerm_network_security_group.net-sec-grp0.id}"
}