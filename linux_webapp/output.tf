output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "output_resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "app_service_plan_name" {
  value = azurerm_service_plan.asp.name
}

output "app_service_plan_sku" {
  value = azurerm_service_plan.asp.sku_name
}

output "app_service_plan_id" {
  value = azurerm_service_plan.asp.id
}

output "linux_web_app_name" {
  value = azurerm_linux_web_app.alwp.name
}