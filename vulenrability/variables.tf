variable "location" {
  type        = string
  default     = "East US"
  description = "The Azure region where lab resources will be deployed."
}

variable "resource_group_name" {
  type        = string
  default     = "rg-azurehackme-lab2"
  description = "The name of the resource group for this lab."
}