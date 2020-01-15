# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~> 1"
}

provider "local" {
  version = "~> 1"
}

provider "random" {
  version = "~> 2"
}