#Create Windows Servers
resource "azurerm_windows_virtual_machine" "win-vm0" {
  depends_on            = [azurerm_network_interface.net-interface1]
  name                  = "${var.vmname}-WNODE"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg0.name}"
  network_interface_ids = ["${azurerm_network_interface.net-interface1.id}"]
  size                  = "${var.vm-size}"
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  enable_automatic_updates = true
  provision_vm_agent       = true
  
  os_disk {
    name                 = "${var.vmname}-win-vm-${random_string.random-win-vm.result}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  computer_name  = "${var.compname}-WINNODE"
  admin_username = "${var.username}"
  admin_password = "${var.password}"

  custom_data = "${base64encode("Param($RemoteHostName = \"${null_resource.intermediates.triggers.full_vm_dns_name}\", $ComputerName = \"${var.compname}-WINNODE\", $WinRmPort = ${var.vm_winrm_port}) ${file(var.pwsfile)}")}"
  
  additional_unattend_content {
      setting = "FirstLogonCommands"
      content = file("FirstLogonCommands.xml")
  }
  additional_unattend_content {
        setting = "AutoLogon"
        content = "<AutoLogon><Password><Value>${var.password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.username}</Username></AutoLogon>"
        }

      #provisioner "file" {
      #  source = "ConfigureRemotingForAnsible.ps1"
      #  destination = "C:\\Scripts\\ConfigureRemotingForAnsible.ps1"
      #  connection {
      #      type = "winrm"
      #      https = true
      #      insecure = true
      #      user = "${var.username}"
      #      password = "${var.password}"
      #      host = "${null_resource.intermediates.triggers.full_vm_dns_name}"
      #      port = "${var.vm_winrm_port}"
      #      timeout = "20m"
      #  }
    #}

    #provisioner "remote-exec" {
    #  inline = [
    #    "powershell.exe -sta -ExecutionPolicy Unrestricted -file C:\\Scripts\\ConfigureRemotingForAnsible.ps1",
    #  ]
    #    connection {
    #        type = "winrm"
    #        https = true
    #        insecure = true
    #        user = "${var.username}"
    #        password = "${var.password}"
    #        host = "${null_resource.intermediates.triggers.full_vm_dns_name}"
    #        port = "${var.vm_winrm_port}"
    #        timeout = "20m"
    #    }
    #}

  tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"
    }
}