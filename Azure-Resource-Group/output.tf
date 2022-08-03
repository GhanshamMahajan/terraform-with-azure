output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  value = azurerm_resource_group.rg.location
}

output "virtual_network" {
  value = azurerm_virtual_network.vnet.name
}

output "virtual_network_location" {
  value = azurerm_virtual_network.vnet.location
}

output "virtual_network_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_address_space" {
  value       = azurerm_virtual_network.vnet.address_space
}

output "vnet_subnets" {
  value       = azurerm_subnet.subnet.*.id
}


