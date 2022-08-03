variable "resource_group_name" {
  default = "ghansham-mahajan"
}

variable "azurerm_virtual_network" {
  default = "ghansham-mahajan"
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