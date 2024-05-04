resource "azurerm_storage_account" "QA-Storage" {
  name                     = "salesqastorageiac"
  resource_group_name      = azurerm_resource_group.QA-RG.name
  location                 = azurerm_resource_group.QA-RG.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "QA"
    Deployedby  = "Terraform"
  }
}
