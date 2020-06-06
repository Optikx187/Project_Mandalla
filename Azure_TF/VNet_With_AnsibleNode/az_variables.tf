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
variable "net-interface-count"{
  default = "2"
  #dynamic
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
############Az LNX bootstrap############
variable "scfile"{
  default  = "/scripts/Bootstrap_Scripts/ansible_lnx_bootstrap.sh"
}
variable "pwshscript"{
  default  = "/scripts/Bootstrap_Scripts/ansible_win_bootstrap.ps1"
}
############ENDAz LNX bootstrap############

