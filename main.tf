# Create a resource group
resource "azurerm_resource_group" "myGroup_younes" {
  name     = "myGroup_terraform_younes_3"
  location = "West Europe"
}

# Create a virtual network
resource "azurerm_virtual_network" "main" {
  name                = "younes-network3"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myGroup_younes.location
  resource_group_name = azurerm_resource_group.myGroup_younes.name
}

# Create a subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.myGroup_younes.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "public_ip" {
  name                = "acceptanceTestPublicIp3"
  resource_group_name = azurerm_resource_group.myGroup_younes.name
  location            = azurerm_resource_group.myGroup_younes.location
  allocation_method   = "Dynamic"
}

# Create a network interface
resource "azurerm_network_interface" "main" {
  name                = "younes-nic3"
  location            = azurerm_resource_group.myGroup_younes.location
  resource_group_name = azurerm_resource_group.myGroup_younes.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}


# Create a Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "younes-nsg3"
  location            = azurerm_resource_group.myGroup_younes.location
  resource_group_name = azurerm_resource_group.myGroup_younes.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8081"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate the NSG with the Network Interface
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  name                  = "younes-vm"
  location              = azurerm_resource_group.myGroup_younes.location
  resource_group_name   = azurerm_resource_group.myGroup_younes.name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = "Standard_DS1_v2"

  admin_username = "testadmin"
  admin_password = "Password1234!"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name = "hostname"
  admin_ssh_key {
    username   = "testadmin"
    public_key = file("~/.ssh/id_azure")
  }
}