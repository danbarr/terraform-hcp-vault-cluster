terraform {
  required_version = "~> 1.9"

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
  create_hvn      = true
  cloud_provider  = "aws"
  region          = "us-east-1"
  vault_tier      = "dev"
  public_endpoint = true
}
