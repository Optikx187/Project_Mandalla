output "Ansible_Host_PublicIP" {
   value = "${azurerm_linux_virtual_machine.lnx-vm0.public_ip_address}"
}
output "Ansible_Host_PrivateIP" {
   value = "${azurerm_linux_virtual_machine.lnx-vm0.private_ip_address}"
}
output "Linux_Node_PublicIP" {
   value = "${azurerm_linux_virtual_machine.lnx-vm1.public_ip_address}"
}
output "Linux_Node_PrivateIP" {
   value = "${azurerm_linux_virtual_machine.lnx-vm1.private_ip_address}"
}
output "Win_Node_PublicIP" {
   value = "${azurerm_windows_virtual_machine.win-vm0.public_ip_address}"

}
output "Win_Node_PrivateIP" {
   value = "${azurerm_windows_virtual_machine.win-vm0.private_ip_address}"

}

