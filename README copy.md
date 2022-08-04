Article tested with the following Terraform and Terraform provider versions

    Terraform v1.1.0
    AzureRM Provider v.2.65

This github code shows you how to create a complete Linux environment and supporting resources with Terraform. Those resources include a virtual network, subnet, public IP address, and more.

To Build the VM we have to create below resources

Create a Resource Group

Create a virtual network

Create a subnet

Create a network security group and SSH inbound rule

Assign NSG to Subnet

Create network interface

Create a public IP address

Create Availability Set

Create a storage account for boot diagnostics

Create SSH key

Create a virtual machine

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



