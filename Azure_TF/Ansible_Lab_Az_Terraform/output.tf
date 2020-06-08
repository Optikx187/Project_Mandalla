output "lnx_vm0_ip" {
   value = "${azurerm_public_ip.az-net-publicip0}"
}
output "win_vm0_ip" {
   value = "${azurerm_public_ip.az-net-publicip1}"
}
output "Ansible_Host_Info" {
   value = "${azurerm_linux_virtual_machine.lnx-vm0}"
}
output "Win_Node" {
   value = "${azurerm_windows_virtual_machine.win-vm0}"
}