output "vulnerable_sql_url" {
  value       = "https://${azurerm_storage_account.insecure_storage.name}.blob.core.windows.net/${azurerm_storage_container.backup_container.name}/${azurerm_storage_blob.sensitive_data.name}"
  description = "URL to the leaked SQL backup"
}

output "vulnerable_csv_url" {
  value       = "https://${azurerm_storage_account.insecure_storage.name}.blob.core.windows.net/${azurerm_storage_container.backup_container.name}/${azurerm_storage_blob.customer_data_blob.name}"
  description = "URL to the leaked Customer CSV data"
}