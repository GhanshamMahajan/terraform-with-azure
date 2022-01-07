variable "resource_group_name" {
  default = "ghansham-mahajan"
}

variable "location" {
  default = "eastus"
}

variable "tags" {
  default = {
    Environment       = "Dev"
    Application_Name  = "Terraform Template"
    Application_Owner = "Ghansham Mahajan"
    Cost_Center       = "ABCD"
  }

}