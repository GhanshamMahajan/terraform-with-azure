# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

#Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

#Create vNet
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

#Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_names
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefixes
}

#Create NSG (Network Security Group)
resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

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
}

#Assign NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "nsgsub" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  count               = var.virtual_machine_count
  name                = "${var.resource_prefix}${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "myNic"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

# Create public IPs
resource "azurerm_public_ip" "pip" {
  count               = var.virtual_machine_count
  name                = "${var.resource_prefix}${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  tags                = var.tags
}
# Create Availability Set
resource "azurerm_availability_set" "avset" {
  name                         = var.azure_availability_set
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
  tags                         = var.tags
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "stg" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Create (and display) an SSH key
resource "tls_private_key" "private-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  count                 = var.virtual_machine_count
  name                  = "${var.resource_prefix}${count.index}"
  location              = azurerm_resource_group.rg.location
  availability_set_id   = azurerm_availability_set.avset.id
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size                  = "Standard_B1ls"
  tags                  = var.tags

  os_disk {
    name                 = "${var.resource_prefix}${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.os_publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }

  computer_name                   = "${var.resource_prefix}${count.index}"
  admin_username                  = var.osadminuser
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.osadminuser
    public_key = tls_private_key.private-ssh-key.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.stg.primary_blob_endpoint
  }
}