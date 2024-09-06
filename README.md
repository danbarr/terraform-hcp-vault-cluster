# HCP Vault Cluster Terraform Module

Terraform module which provisions a simple HCP Vault cluster for demonstration purposes. Only a subset of the available configuration options are exposed.

By default a HashiCorp Virtual Network is also created, unless `create_hvn = false` the `hvn_id` of an existing HVN is supplied.

Prerequisites:

- An HCP organization
- HCP "Contributor" credentials set as environment variables `HCP_CLIENT_ID` and `HCP_CLIENT_SECRET` (see the HCP provider [authentication guide](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/guides/auth)). Optionally specify `HCP_PROJECT_ID`. If not included, the oldest project in the organization will be used.
  - If using a project-level service principal, `HCP_PROJECT_ID` is required

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | >= 0.57 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | >= 0.57 |

## Resources

| Name | Type |
|------|------|
| [hcp_hvn.this](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/hvn) | resource |
| [hcp_vault_cluster.this](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/vault_cluster) | resource |
| [hcp_vault_cluster_admin_token.admin](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/vault_cluster_admin_token) | resource |
| [hcp_hvn.selected](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/hvn) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | This prefix will be used to generate unique resource names. | `string` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | CIDR block for the HVN. | `string` | `"172.25.16.0/20"` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider where the HVN and Vault cluster will be located. Must be specified if `create_hvn = true`. | `string` | `null` | no |
| <a name="input_create_hvn"></a> [create\_hvn](#input\_create\_hvn) | Whether to create a new HVN or use an existing one. | `bool` | `false` | no |
| <a name="input_hvn_id"></a> [hvn\_id](#input\_hvn\_id) | ID of the HVN. If `create_hvn = false`, this must be set to an existing HVN ID. If left blank and `create_hvn = true`, an ID will be generated for you. | `string` | `""` | no |
| <a name="input_min_vault_version"></a> [min\_vault\_version](#input\_min\_vault\_version) | The minimum Vault version to use when creating the cluster. If not specified, it is defaulted to the version that is currently recommended by HCP. | `string` | `null` | no |
| <a name="input_public_endpoint"></a> [public\_endpoint](#input\_public\_endpoint) | Whether the Vault cluster should have a public endpoint. If false, you will need to set up HVN peering to reach the cluster. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the HVN and Vault cluster will be located. Must be specified if `create_hvn = true`. | `string` | `null` | no |
| <a name="input_vault_cluster_id"></a> [vault\_cluster\_id](#input\_vault\_cluster\_id) | ID for the Vault cluster. If left blank, an ID will be generated for you. | `string` | `""` | no |
| <a name="input_vault_tier"></a> [vault\_tier](#input\_vault\_tier) | Sizing tier of the Vault cluster. | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hvn_id"></a> [hvn\_id](#output\_hvn\_id) | ID of the HashiCorp Virtual Network (HVN). |
| <a name="output_vault_admin_token"></a> [vault\_admin\_token](#output\_vault\_admin\_token) | Admin token for the HCP Vault cluster. |
| <a name="output_vault_cluster_id"></a> [vault\_cluster\_id](#output\_vault\_cluster\_id) | ID of the HCP Vault cluster. |
| <a name="output_vault_private_endpoint_url"></a> [vault\_private\_endpoint\_url](#output\_vault\_private\_endpoint\_url) | Private endpoint of the HCP Vault cluster. |
| <a name="output_vault_public_endpoint_url"></a> [vault\_public\_endpoint\_url](#output\_vault\_public\_endpoint\_url) | Public endpoint of the HCP Vault cluster. |
<!-- END_TF_DOCS -->