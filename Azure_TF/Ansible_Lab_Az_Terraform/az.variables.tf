############AzInfo############
#location 
variable "location" {
  default = "eastus"
}
#application name, used for rg name in main 
variable "app_name" {
  default = "TFTest"
}
#environment name, used for rg name in main 
variable "environment" {
  default = "TST"
}
variable "account_replication_type"{
  default = "LRS"
}
variable "account_tier"{
  default = "Standard"
}
variable "vmname"{
  default = "TFTestVM"
}
variable "compname"{
  default = "TFTest"
}
variable "vm-size"{
  default = "Standard_DS1_v2" 
}
############ENDAzInfo############
############Networking############
#vnet
variable "az-net-vnet0-cidr0"{
  default = "10.0.0.0/16"
  }
#subnet
variable "az-net-subnet0-cidr0"{
  default = "10.0.1.0/24"
}
variable "ip-allocation"{
  default = "Static"
  #dynamic
}
variable "source_address"{
  default = "74.98.165.79"
  #dynamic
}
variable "vm_winrm_port" {
    description = "WinRM Public Port"
    default = "5986"
}
variable "azure_dns_suffix" {
    description = "Azure DNS suffix for the Public IP"
    default = "cloudapp.azure.com"
}
############ENDNetworking############
############Connection Vars############
#stored in terraform.tfvars
variable "client_id"{
  description = "Azure client ID"
}
variable "client_secret"{
  description = "Azure client secret"
}
variable "subscription_id" {
  description = "Azure subscription  ID"
}
variable "tenant_id"{
  description = "Azure subscription  ID"
}
############END Connection Vars############
############Az OS credential vars############
variable "username"{
  description = "Azure OS credential: Username"
}
variable "password"{
  description = "Azure OS credential: Password"
}
############ENDAz OS credential vars############
############Az bootstrap vars############
variable "bashfile"{
  default  = "./ansible_lnx_bootstrap.sh"
}
variable "pwsfile"{
  default  = "./ConfigureRemotingForAnsible.ps1"
}
############END Az bootstrap vars############
############Additional vars############
resource "null_resource" "intermediates" {
    triggers = {
        full_vm_dns_name = "${var.vmname}.${var.location}.${var.azure_dns_suffix}"
    }
}
#first step is to create random text for unique names 
#delete if no errors witout storage account
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.rg0.name}"
    }
    byte_length = 8
}
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
############Additional vars############

