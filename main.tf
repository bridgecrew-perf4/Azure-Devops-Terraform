provider "azurerm"{
    version = "> 0.14"
    features {}
}

terraform {
    backend "azurerm" {
        resource_group_name     = "tf_rg_blobstore"
        storage_account_name    = "tfstoragemandalorian"
        container_name          = "tfstate"
        key                     = "terraform.tfstate"
    }
}

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}

resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "eastus"
}

data "azurerm_subscription" "current" {
}

output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

resource "azurerm_container_group" "tfcg_test" {
    name                    = "weatherapi"
    location                = azurerm_resource_group.tf_test.location
    resource_group_name     = azurerm_resource_group.tf_test.name

    ip_address_type         = "public"
    dns_name_label          = "officialmandalorianwa"
    os_type                 = "Linux"

    container {
        name                = "weatherapi"
            image           = "officialmandalorian/weatherapi:${var.imagebuild}"
            cpu             = "1"
            memory          = "1"

            ports {
                port        = 80
                protocol    = "TCP"
            }
    }
}
