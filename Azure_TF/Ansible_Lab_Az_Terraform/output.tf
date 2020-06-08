output "Ansible_Host_Info" {
   value = "${azurerm_linux_virtual_machine.lnx-vm0}"
}
output "Win_Node" {
   value = "${azurerm_windows_virtual_machine.win-vm0}"
}