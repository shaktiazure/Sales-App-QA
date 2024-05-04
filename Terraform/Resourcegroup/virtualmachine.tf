variable "prefix" {
  default = "exSales-QA-APP"
}


resource "azurerm_virtual_network" "QA-VNET" {
  name                = "${var.prefix}-network"
  address_space       = ["50.0.0.0/16"]
  location            = azurerm_resource_group.QA-RG.location
  resource_group_name = azurerm_resource_group.QA-RG.name
}

resource "azurerm_subnet" "QA-Subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.QA-RG.name
  virtual_network_name = azurerm_virtual_network.QA-VNET.name
  address_prefixes     = ["50.0.2.0/24"]
}

resource "azurerm_network_interface" "QA-NIC" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.QA-RG.location
  resource_group_name = azurerm_resource_group.QA-RG.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.QA-Subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "QA-VM" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.QA-RG.location
  resource_group_name   = azurerm_resource_group.QA-RG.name
  network_interface_ids = [azurerm_network_interface.QA-NIC.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "Sales-QA-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hSales-QA-VM"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "QA"
    Deployedby  = "Terraform"
  }
}