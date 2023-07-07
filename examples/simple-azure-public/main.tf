terraform {
  required_version = "~> 1.2"

  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.57"
    }
  }
}

provider "hcp" {}

module "hcp_vault_cluster" {
  source = "../../"

  prefix          = "example"
  cloud_provider  = "azure"
  region          = "centralus"
  vault_tier      = "dev"
  public_endpoint = true
}
