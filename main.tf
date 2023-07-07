terraform {
  required_version = ">= 1.2"

  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = ">= 0.57"
    }
  }
}

locals {
  # Supported regions for HCP Vault as of July 2023
  supported_regions = {
    "aws"   = ["us-east-1", "us-east-2", "us-west-2", "ca-central-1", "eu-central-1", "eu-west-1", "eu-west-2", "ap-northeast-1", "ap-southeast-1", "ap-southeast-2"]
    "azure" = ["westus2", "eastus", "centralus", "eastus2", "westeurope", "northeurope", "francecentral", "uksouth"]
  }

  region_short = replace(var.region, "-", "")

  hvn_id     = var.hvn_id != "" ? var.hvn_id : "${var.prefix}-hvn-${var.cloud_provider}-${local.region_short}"
  cluster_id = var.vault_cluster_id != "" ? var.vault_cluster_id : "${var.prefix}-vault-${var.cloud_provider}-${local.region_short}"
}

resource "hcp_hvn" "vault" {
  count = var.create_hvn ? 1 : 0

  hvn_id         = local.hvn_id
  cloud_provider = var.cloud_provider
  region         = var.region
  cidr_block     = var.cidr_block

  lifecycle {
    precondition {
      condition     = contains(local.supported_regions[var.cloud_provider], var.region)
      error_message = "${var.region} is not a supported region for HCP Vault in ${var.cloud_provider}"
    }
  }
}

resource "hcp_vault_cluster" "this" {
  hvn_id          = local.hvn_id
  cluster_id      = local.cluster_id
  public_endpoint = var.public_endpoint
  tier            = var.vault_tier
}

resource "hcp_vault_cluster_admin_token" "admin" {
  cluster_id = hcp_vault_cluster.this.cluster_id
}
