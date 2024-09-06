variable "prefix" {
  type        = string
  description = "This prefix will be used to generate unique resource names."
}

variable "create_hvn" {
  type        = bool
  description = "Whether to create a new HVN or use an existing one."
  default     = false
}

variable "hvn_id" {
  type        = string
  description = "ID of the HVN. If `create_hvn = false`, this must be set to an existing HVN ID. If left blank and `create_hvn = true`, an ID will be generated for you."
  default     = ""

  validation {
    condition     = var.hvn_id == "" ? true : can(regex("^[a-zA-Z0-9-]{3,36}$", var.hvn_id))
    error_message = "HVN ID must be 3-36 characters and can only include letters, numbers, and hyphens."
  }
  validation {
    condition     = var.create_hvn ? true : can(regex("^[a-zA-Z0-9-]{3,36}$", var.hvn_id))
    error_message = "You must specify an existing HVN ID since `create_hvn = false`."
  }
}

variable "cloud_provider" {
  type        = string
  description = "Cloud provider where the HVN and Vault cluster will be located. Must be specified if `create_hvn = true`."
  default     = null

  validation {
    condition     = var.create_hvn ? contains(["aws", "azure"], var.cloud_provider) : true
    error_message = "The supported providers are 'aws' and 'azure'."
  }
}

locals {
  # Supported regions for HCP Vault as of August 2024
  # AWS: https://developer.hashicorp.com/hcp/docs/hcp/supported-env/aws
  # Azure: https://developer.hashicorp.com/hcp/docs/hcp/supported-env/azure
  supported_regions = {
    "aws"   = ["us-east-1", "us-east-2", "us-west-2", "ca-central-1", "eu-west-1", "eu-west-2", "eu-central-1", "ap-northeast-1", "ap-southeast-1", "ap-southeast-2"]
    "azure" = ["westus2", "eastus", "centralus", "eastus2", "canadacentral", "westeurope", "northeurope", "francecentral", "uksouth", "southeastasia", "japaneast", "australiasoutheast"]
  }
}

variable "region" {
  type        = string
  description = "Region where the HVN and Vault cluster will be located. Must be specified if `create_hvn = true`."
  default     = null

  validation {
    condition     = var.create_hvn ? var.region != "" : true
    error_message = "Region must be specified if `create_hvn = true`."
  }
  validation {
    condition     = var.cloud_provider == "aws" ? contains(local.supported_regions["aws"], var.region) : true
    error_message = "Must specify a supported AWS region. Refer to https://developer.hashicorp.com/hcp/docs/hcp/supported-env/aws"
  }
  validation {
    condition     = var.cloud_provider == "azure" ? contains(local.supported_regions["azure"], var.region) : true
    error_message = "Must specify a supported Azure region. Refer to https://developer.hashicorp.com/hcp/docs/hcp/supported-env/azure"
  }
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the HVN."
  default     = "172.25.16.0/20"

  validation {
    condition     = can(cidrhost(var.cidr_block, 32))
    error_message = "The CIDR block must be a valid IPv4 CIDR."
  }
}

variable "vault_cluster_id" {
  type        = string
  description = "ID for the Vault cluster. If left blank, an ID will be generated for you."
  default     = ""

  validation {
    condition     = var.vault_cluster_id == "" ? true : can(regex("^[a-zA-Z0-9-]{3,36}$", var.vault_cluster_id))
    error_message = "Cluster ID must be 3-36 characters and can only include letters, numbers, and hyphens."
  }
}

variable "vault_tier" {
  type        = string
  description = "Sizing tier of the Vault cluster."
  default     = "dev"

  validation {
    condition     = contains(["dev", "starter_small", "standard_small", "standard_medium", "standard_large", "plus_small", "plus_medium", "plus_large"], var.vault_tier)
    error_message = "Invalid tier was specified."
  }
}

variable "min_vault_version" {
  type        = string
  description = "The minimum Vault version to use when creating the cluster. If not specified, it is defaulted to the version that is currently recommended by HCP."
  default     = null
}

variable "public_endpoint" {
  type        = bool
  description = "Whether the Vault cluster should have a public endpoint. If false, you will need to set up HVN peering to reach the cluster."
  default     = false
}
