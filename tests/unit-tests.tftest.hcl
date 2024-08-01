variables {
  prefix = "tftest"
}

run "create_hvn" {
  command = plan

  variables {
    create_hvn     = true
    cloud_provider = "aws"
    region         = "us-east-1"
  }

  assert {
    condition     = hcp_hvn.this[0].hvn_id == "tftest-hvn-aws-useast1"
    error_message = "HVN ID does not match expected."
  }

  assert {
    condition     = hcp_vault_cluster.this.cluster_id == "tftest-vault-aws-useast1"
    error_message = "Vault cluster ID does not match expected."
  }
}

run "existing_hvn" {
  command = plan

  variables {
    create_hvn = false
    hvn_id     = "tftest-hvn"
  }

  override_data {
    target = data.hcp_hvn.selected[0]
    values = {
      hvn_id         = "tftest-hvn"
      cloud_provider = "aws"
      region         = "us-east-1"
    }
  }

  assert {
    condition     = hcp_vault_cluster.this.cluster_id == "tftest-vault-aws-useast1"
    error_message = "Vault cluster ID does not match expected."
  }

  assert {
    condition     = hcp_vault_cluster.this.hvn_id == "tftest-hvn"
    error_message = "Vault cluster's HVN ID does not match expected."
  }

  assert {
    condition     = data.hcp_hvn.selected[0].region == "us-east-1"
    error_message = "Cluster region does not match expected."
  }
}
