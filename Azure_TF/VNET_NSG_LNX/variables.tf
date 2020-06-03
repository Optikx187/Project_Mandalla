#location 
variable "location" {
  default = "eastus"
}
#resource group
variable "resourcegroup" {
  default = "TerriformTest"
}
#application name 
variable "app_name" {
  default = "TFTest"
}
#environment name
variable "environment" {
  default = "TST"
}
#Networking
#vnet
variable "network-vnet-cidr"{
  default = "10.0.0.0/16"
  }
#subnet
variable "network-subnet-cidr"{
  default = "10.0.2.0/24"
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