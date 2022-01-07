# Azure - Resource Group Module
## Introduction
    In this module we are going to create Resource Gruop in Azure
## Provider
| Name | Version |
|------|---------|
| azurerm | >= 2.0.0 |

## main.tf

## Variable 
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| Name | Resource Group Name (RG) | `string` | n/a | yes |
| location | Azure Region | `string` | n/a | yes |
| tags | Tags will be applied to Resource Group | `map(string)` | n/a | yes |

## Output
| Name | Description |
|------|-------------|
| id | Resource group id |
| location | Resource group location |
| name | Resource group name |
| rg | Resource group resource |



