variables {
  prefix         = "test"
  create_hvn     = true
  cloud_provider = "aws"
  region         = "us-east-1"
}

mock_provider "hcp" {}

run "min_valid_inputs" {
  command = plan
}

run "invalid_values" {
  command = plan

  variables {
    create_hvn       = true
    cloud_provider   = "bad"
    cidr_block       = "10.0.0.0/40"
    vault_cluster_id = "invalid_cluster_id"
    vault_tier       = "invalid"
  }

  expect_failures = [
    var.cloud_provider,
    var.cidr_block,
    var.vault_cluster_id,
    var.vault_tier,
  ]
}

run "invalid_hvn" {
  command = plan

  variables {
    create_hvn = false
    hvn_id     = "invalid_hvn_id"
  }

  expect_failures = [var.hvn_id]
}

run "invalid_aws_region" {
  command = plan

  variables {
    create_hvn     = true
    cloud_provider = "aws"
    region         = "eastus"
  }

  expect_failures = [var.region]
}

run "invalid_azure_region" {
  command = plan

  variables {
    create_hvn     = true
    cloud_provider = "azure"
    region         = "us-east-1"
  }

  expect_failures = [var.region]
}
