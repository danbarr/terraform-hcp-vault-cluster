terraform {
  # 1.9 required for new variable validations
  required_version = ">= 1.9"

  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = ">= 0.57"
    }
  }
}

locals {
  region         = var.create_hvn ? var.region : data.hcp_hvn.selected[0].region
  region_short   = replace(local.region, "-", "")
  cloud_provider = var.create_hvn ? var.cloud_provider : data.hcp_hvn.selected[0].cloud_provider

  hvn_id     = var.hvn_id != "" ? var.hvn_id : "${var.prefix}-hvn-${local.cloud_provider}-${local.region_short}"
  cluster_id = var.vault_cluster_id != "" ? var.vault_cluster_id : "${var.prefix}-vault-${local.cloud_provider}-${local.region_short}"
}

data "hcp_hvn" "selected" {
  count = var.create_hvn ? 0 : 1

  hvn_id = var.hvn_id
}

resource "hcp_hvn" "this" {
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
  depends_on        = [hcp_hvn.this]
  hvn_id            = var.create_hvn ? hcp_hvn.this[0].hvn_id : data.hcp_hvn.selected[0].hvn_id
  cluster_id        = local.cluster_id
  public_endpoint   = var.public_endpoint
  tier              = var.vault_tier
  min_vault_version = var.min_vault_version
}

resource "hcp_vault_cluster_admin_token" "admin" {
  cluster_id = hcp_vault_cluster.this.cluster_id
}
