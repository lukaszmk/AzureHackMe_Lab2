resource "azurerm_storage_account" "insecure_storage" {
  name                     = "sthackme${lower(random_id.storage_suffix.hex)}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # MISCONFIGURATION 1: Allows individual containers to opt into anonymous public access
  allow_nested_items_to_be_public = true

  # MISCONFIGURATION 2: Public network access is completely open to all internet sources
  public_network_access_enabled = true

  network_rules {
    default_action             = "Allow"
    bypass                     = ["Logging", "Metrics"]
  }
}

resource "azurerm_storage_container" "backup_container" {
  name                  = "backups"
  storage_account_id    = azurerm_storage_account.insecure_storage.id
  container_access_type = "blob" # MISCONFIGURATION 3: Enables anonymous read access for blobs within this container
}

resource "azurerm_storage_blob" "sensitive_data" {
  name                   = "prod_dump.sql"
  storage_account_name   = azurerm_storage_account.insecure_storage.name
  storage_container_name = azurerm_storage_container.backup_container.name
  type                   = "Block"
  
  # Changed from source_content to source:
  source                 = "${path.module}/prod_dump.sql" 
}

resource "azurerm_storage_blob" "customer_data_blob" {
  name                   = "customer_data.csv"
  storage_account_name   = azurerm_storage_account.insecure_storage.name
  storage_container_name = azurerm_storage_container.backup_container.name
  type                   = "Block"
  

  source                 = "${path.module}/customer_data.csv" 
}