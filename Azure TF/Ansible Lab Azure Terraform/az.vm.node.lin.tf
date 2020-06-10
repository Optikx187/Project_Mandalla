# Create ansible virtual machine
resource "azurerm_linux_virtual_machine" "lnx-vm1" {
    depends_on            = [azurerm_network_interface.net-interface2]
    name                  = "${var.vmname}-LNDE"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.rg0.name}"
    network_interface_ids = ["${azurerm_network_interface.net-interface2.id}"]
    size                  = "${var.vm-size}" 
                            #Standard_DS4_v2
    os_disk {
        name                 = "${var.vmname}-lin${random_string.random-lin-vm.result}-os-disk"
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
                             #"Premium_LRS"
    }
    computer_name  = "${var.compname}-LNDE"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
    source_image_reference {
        #publisher = "Canonical"
        #offer     = "UbuntuServer"
        #sku       = "16.04.0-LTS"
        #version   = "latest"
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7.5"
        version   = "latest"
    }
    disable_password_authentication = false
#    admin_ssh_key {
#        username       = var.user
#        public_key     = tls_private_key.ssh_key.public_key_openssh
#    }
    tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"
    }
}
