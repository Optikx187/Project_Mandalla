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