provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being u$  version = "=2.5.0"
  version         ="~>2.0"
  client_id       ="${var.client_id}"
  client_secret   ="${var.client_secret}"
  subscription_id ="${var.subscription_id}"
  tenant_id       ="${var.tenant_id}"

features {}
}
#create resource group
resource "azurerm_resource_group" "rg0" {
 name     = "${var.app_name}-${var.environment}-rg"
 location = "${var.location}"
 tags = {
 application = "${var.app_name}"
 environment = "${var.environment}"
  }
}
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
# Create a subnet for Network VMs
resource "azurerm_subnet" "az-net-subnet0" {
  name                 = "${var.app_name}-${var.environment}-subnet"
  address_prefix       = "${var.az-net-subnet0-cidr0}"
  virtual_network_name = "${azurerm_virtual_network.az-net-vnet0.name}"
  resource_group_name  = "${azurerm_resource_group.rg0.name}"
}
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
# public IP resource 2 Windows VM 1
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
#NSG for Linux and windows vm's
resource "azurerm_network_security_group" "net-sec-grp0" {
    name                = "${var.app_name}-${var.environment}-nsg"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg0.name}"
    security_rule {
        name                       = "Allow SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*" #public ip for personal use.  
        destination_address_prefix = "*"
    
    }
        security_rule {
        name                       = "Allow RDP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*" #public ip for personal use.  
        destination_address_prefix = "*"
    
    }
    #NSG
    security_rule {
        name                       = "Allow Home Public IP"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "74.98.165.79" #public ip for personal use.  
        destination_address_prefix = "*"
    }
    tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"
    }
}
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
#create storage account
#first step is to create random text for unique names 
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.rg0.name}"
    }
    byte_length = 8
}
#storage account
resource "azurerm_storage_account" "storage_acc_0" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.rg0.name}"
    location                    = "${var.location}"
    account_replication_type    = "${var.account_replication_type}"
    account_tier                = "${var.account_tier}"

    tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"
    }
}
# Create (and display) an SSH key
#resource "tls_private_key" "ssh_key" {
#  algorithm = "RSA"
#  rsa_bits = 4096
#}
#output "tls_private_key" { value = "${tls_private_key.ssh_key.private_key_pem}" }
#create random strings to use
# Generate randon name for lin vm 
resource "random_string" "random-lin-vm" {
  length  = 2
  special = false
  lower   = true
  upper   = false
  number  = true
}

# Generate randon name for win vm
resource "random_string" "random-win-vm" {
  length  = 2
  special = false
  lower   = true
  upper   = false
  number  = true
}
#ex "win-${random_string.random-win-vm.result}-"
# Create virtual machine
resource "azurerm_linux_virtual_machine" "lnx-vm0" {
    depends_on            =[azurerm_network_interface.net-interface0]
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
        "script": "${base64encode(file(var.scfile))}"
    }
    PROT
}
#Create Windows Servers
# Create Windows web Server -fix vars tomorrow
resource "azurerm_windows_virtual_machine" "win-vm0" {
  depends_on            = [azurerm_network_interface.net-interface1]
  name                  = "${var.vmname}-WNODE"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg0.name}"
  network_interface_ids = ["${azurerm_network_interface.net-interface1.id}"]
  size                  = "${var.vm-size}"
  
  os_disk {
    name                 = "${var.vmname}-win-vm-${random_string.random-win-vm.result}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  computer_name  = "${var.compname}-WINNODE"
  admin_username = "${var.username}"
  admin_password = "${var.password}"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  enable_automatic_updates = true
  provision_vm_agent       = true
  tags = {
         application = "${var.app_name}"
         environment = "${var.environment}"
    }
}
#bootstrap remote powershell into windows host
resource "azurerm_virtual_machine_extension" "win-vm0bootloader" {
    depends_on            = [azurerm_windows_virtual_machine.win-vm0]
    name                  = "${var.vmname}-winnode-vmext"
    virtual_machine_id    = azurerm_windows_virtual_machine.win-vm0.id
    publisher             = "Microsoft.Azure.Extensions"
    type                  = "CustomScript"
    type_handler_version  = "2.0"

    protected_settings = <<PROT
    {
        "script": "${base64encode(file(var.pwshscript))}"
    }
    PROT
}


