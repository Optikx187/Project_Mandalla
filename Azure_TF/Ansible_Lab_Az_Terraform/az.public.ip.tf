# public IP resource Lin Ansible VM 1
resource "azurerm_public_ip" "az-net-publicip0" {
    name                         = "${var.app_name}-${var.environment}-pip0"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.rg0.name}"
    allocation_method            = "Static"
                                    #dynamic
    tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"

    }
}
 #public IP resource Windows Node VM 1
resource "azurerm_public_ip" "az-net-publicip1" {
    depends_on                  = [azurerm_public_ip.az-net-publicip0]
    name                         = "${var.app_name}-${var.environment}-pip1"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.rg0.name}"
    allocation_method            = "Static"
                                   #dynamic
    tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"

    }
}
 #public IP resource Windows Linux Node VM 1
resource "azurerm_public_ip" "az-net-publicip2" {
    depends_on                  = [azurerm_public_ip.az-net-publicip1]
    name                         = "${var.app_name}-${var.environment}-pip2"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.rg0.name}"
    allocation_method            = "Static"
                                    #dynamic
    tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"

    }
}