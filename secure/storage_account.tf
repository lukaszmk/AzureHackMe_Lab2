# Data source to dynamically fetch your local computer's public IP address.
# This prevents the Azure Storage Firewall from blocking your local Terraform deployment run!
data "http" "client_ip" {
  url = "https://ifconfig.me/ip"
}

resource "azurerm_storage_account" "secure_storage" {
  name                     = "stsecure${lower(random_id.storage_suffix.hex)}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # REMEDIATION 1: Disallow individual containers from overriding public access controls globally
  allow_nested_items_to_be_public = false

  # Enterprise Security Baseline Encryption Requirements
  https_traffic_only_enabled = true
  min_tls_version           = "TLS1_2"

  # REMEDIATION 2: Activate the built-in firewall and drop all public internet traffic by default
  network_rules {
    default_action = "Deny"

    # Explicitly whitelist only your current public administrative IP address
    ip_rules = [chomp(data.http.client_ip.response_body)]
    bypass   = ["Logging", "Metrics", "AzureServices"]
  }
}

resource "azurerm_storage_container" "backup_container" {
  name                 = "backups"
  storage_account_name = azurerm_storage_account.secure_storage.name

  # REMEDIATION 3: Enforce strict private access. Anonymous read queries are completely blocked.
  container_access_type = "private"
}

resource "azurerm_storage_blob" "sensitive_data" {
  name                   = "prod_dump.sql"
  storage_account_name   = azurerm_storage_account.secure_storage.name
  storage_container_name = azurerm_storage_container.backup_container.name
  type                   = "Block"
  source                 = "${path.module}/prod_dump.sql"
}

resource "azurerm_storage_blob" "customer_data_blob" {
  name                   = "customer_data.csv"
  storage_account_name   = azurerm_storage_account.secure_storage.name
  storage_container_name = azurerm_storage_container.backup_container.name
  type                   = "Block"
  source                 = "${path.module}/customer_data.csv"
}
