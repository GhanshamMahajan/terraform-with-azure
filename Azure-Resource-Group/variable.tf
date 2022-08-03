variable "resource_group_name" {
  default = "ghansham-mahajan-rg"
}

variable "virtual_network" {
  default = "ghansham-mahajan-vnet"
}

variable "location" {
  default = "westindia"
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
  default = ["subnet1"]
}