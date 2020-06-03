provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being u$  version = "=2.5.0"

  client_id       =var.client_id
  client_secret   =var.client_secret
  subscription_id =var.subscription_id
  tenant_id       =var.tenant_id

features {}
}
#create resource group
resource "azurerm_resource_group" "network-rg" {
 name     = "${var.app_name}-${var.environment}-rg"
 location = var.location
 tags = {
 application = var.app_name
 environment = var.environment
  }
}

#create vnet
resource "azurerm_virtual_network" "network-vnet" {
 name = "${var.app_name}-${var.environment}-vnet"
 address_space = [var.network-vnet-cidr]
 resource_group_name = azurerm_resource_group.network-rg.name
 location = var.location
tags = {
    application = var.app_name
    environment = var.environment
  }
}
# Create a subnet for Network
resource "azurerm_subnet" "network-subnet" {
  name                 = "${var.app_name}-${var.environment}-subnet"
  address_prefix       = var.network-subnet-cidr
  virtual_network_name = azurerm_virtual_network.network-vnet.name
  resource_group_name  = azurerm_resource_group.network-rg.name
}

# public IP resource
resource "azurerm_public_ip" "network-publicip" {
    name                         = "${var.app_name}-${var.environment}-publicip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.network-rg.name
    allocation_method            = "Dynamic"

    tags = {
         application = var.app_name
         environment = var.environment

    }
}

resource "azurerm_network_security_group" "network-nsg" {
    name                = "${var.app_name}-${var.environment}-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.network-rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
         application = var.app_name
         environment = var.environment
    }
}
#Create virtual network interface card
resource "azurerm_network_interface" "network-nic" {
    name                        = "${var.app_name}-${var.environment}-nic"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.network-rg.name

    ip_configuration {
        name                          = "${var.app_name}-${var.environment}-nicconfig"
        subnet_id                     = azurerm_subnet.network-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.network-publicip.id
    }

    tags = {
         application = var.app_name
         environment = var.environment
    }
}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "network-sgxni" {
    network_interface_id      = azurerm_network_interface.network-nic.id
    network_security_group_id = azurerm_network_security_group.network-nsg.id
}
#create storage account

#first step is to create random text for unique names 
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.network-rg.name
    }

    byte_length = 8
}
#storage account
resource "azurerm_storage_account" "network-sa" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.network-rg.name
    location                    = var.location
    account_replication_type    = var.account_replication_type
    account_tier                = var.account_tier

    tags = {
         application = var.app_name
         environment = var.environment
    }
}
# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { value = "${tls_private_key.example_ssh.private_key_pem}" }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "network-lnx-vm" {
    name                  = var.vmname
    location              = var.location
    resource_group_name   = azurerm_resource_group.network-rg.name
    network_interface_ids = [azurerm_network_interface.network-nic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk1"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
       # create_option        = "FromImage"
    }
    #os_profile {
        computer_name  = var.compname
        admin_username = "optikx"
        admin_password = "P@ssword187!@#$%"
    #}
    source_image_reference {
         publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }
   # os_profile_linux_config {
    disable_password_authentication = false
   # }
#    admin_ssh_key {
#        username       = var.user
#        public_key     = tls_private_key.example_ssh.public_key_openssh
#    }

#    boot_diagnostics {
#        storage_account_uri = azurerm_storage_account.network-sa.primary_blob_endpoint
#    }
    tags = {
         application = var.app_name
         environment = var.environment
    }
}

