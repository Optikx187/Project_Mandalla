# Create ansible virtual machine
resource "azurerm_linux_virtual_machine" "lnx-vm0" {
    depends_on            = [azurerm_network_interface.net-interface0]
    name                  = "${var.vmname}-ANSI"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.rg0.name}"
    network_interface_ids = ["${azurerm_network_interface.net-interface0.id}"]
    size                  = "${var.vm-size}" 
                            #Standard_DS4_v2
    os_disk {
        name                 = "${var.vmname}-lin-vm-${random_string.random-lin-vm.result}-os-disk"
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
                             #"Premium_LRS"
    }
    computer_name  = "${var.compname}-ANSI"
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
#bootstrap linux host to install updates and ansible
resource "azurerm_virtual_machine_extension" "lnx-vm0bootloader" {
    depends_on            = [azurerm_linux_virtual_machine.lnx-vm0]
    name                  = "${var.vmname}-ansi-vmext"
    virtual_machine_id    = azurerm_linux_virtual_machine.lnx-vm0.id
    publisher             = "Microsoft.Azure.Extensions"
    type                  = "CustomScript"
    type_handler_version  = "2.0"
    protected_settings = <<PROT
    {
        "script": "${base64encode(file(var.bashfile))}"
    }
    PROT
}
#