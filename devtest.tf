resource "azurerm_resource_group" "test" {
  name     = "testlab"
  location = "West Europe"
}

resource "azurerm_dev_test_lab" "test" {
  name                = "example-devtestlab"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  tags {
    "course" = "biolab"
  }
}

resource "azurerm_dev_test_virtual_network" "test" {
  name                = "example-network"
  lab_name            = "${azurerm_dev_test_lab.test.name}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  subnet {
    use_public_ip_address           = "Allow"
    use_in_virtual_machine_creation = "Allow"
  }
}

resource "azurerm_dev_test_linux_virtual_machine" "test" {
  name                   = "example-vm03"
  lab_name               = "${azurerm_dev_test_lab.test.name}"
  resource_group_name    = "${azurerm_resource_group.test.name}"
  location               = "${azurerm_resource_group.test.location}"
  size                   = "Standard_D2s_v3"
  username               = "royd"
  ssh_key                = "${file("~/.ssh/roy.key.pub")}"
  lab_virtual_network_id = "${azurerm_dev_test_virtual_network.test.id}"
  lab_subnet_name        = "${azurerm_dev_test_virtual_network.test.subnet.0.name}"
  storage_type           = "Premium"
  notes                  = "Some notes about this Virtual Machine."

  gallery_image_reference {
    offer     = "UbuntuServer"
    publisher = "Canonical"
    sku       = "18.10"
    version   = "latest"
  }
}