variable "virtual_machine_count" {
  default = "3"
}

variable "resource_group_name" {
  default = "ghansham-mahajan-rg"
}

variable "virtual_network" {
  default = "ghansham-mahajan-vnet"
}

variable "location" {
  default = "eastus"
}

variable "tags" {
  default = {
    Environment       = "Dev"
    Application_Name  = "Terraform Template"
    Application_Owner = "Ghansham Mahajan"
    Team              = "Infra Team"
  }
}

variable "network_security_group" {
  default = "ghansham-mahajan-nsg"
}

variable "address_space" {
  default = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  default = ["10.0.1.0/24"]
}

variable "subnet_names" {
  default = "subnet"
}

variable "public_ip_name" {
  default = "Ghansham-Mahajan-PIP"
}

variable "nic_name" {
  default = "ghansham_mahajan_nic"
}

variable "resource_prefix" {
  default = "OMWEIASDEVPAP"
}

variable "os_publisher" {
  default = "Canonical"
}

variable "offer" {
  default = "UbuntuServer"
}

variable "sku" {
  default = "18.04-LTS"
}

variable "osadminuser" {
  default = "osadmin"
}

variable "azure_availability_set" {
  default = "OMWEIASDEVPAVS01"
}