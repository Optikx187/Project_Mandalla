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
############ENDAzInfo############
############Networking############
#vnet
variable "network-vnet-cidr0"{
  default = "10.0.0.0/16"
  }
#subnet
variable "network-subnet-cidr0"{
  default = "10.0.1.0/24"
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
############ENDAz LNX bootstrap############

