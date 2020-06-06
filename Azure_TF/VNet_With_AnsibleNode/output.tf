output "lnx_vm0_ip" {
   value = "${azurerm_public_ip.az-net-publicip0}"
}
output "vim_vm0_ip" {
   value = "${azurerm_public_ip.az-net-publicip1}"
}