# public IP resource Linux VM 1
resource "azurerm_public_ip" "az-net-publicip0" {
    name                         = "${var.app_name}-${var.environment}-publicip0"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.rg0.name}"
    allocation_method            = "Static"
                                    #dynamic
    tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"

    }
}
# public IP resource Windows VM 1
resource "azurerm_public_ip" "az-net-publicip1" {
    name                         = "${var.app_name}-${var.environment}-publicip1"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.rg0.name}"
    allocation_method            = "Static"
                                    #dynamic
    tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"

    }
}