# terraform-helm-release
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.36 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.36 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.7.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.main](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_iam_policy_document.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_value_files"></a> [additional\_value\_files](#input\_additional\_value\_files) | A list of additional value files. It will work in the same way as helm -f value1.yaml -f value2.yaml | `list(any)` | `[]` | no |
| <a name="input_assume_role_condition_test"></a> [assume\_role\_condition\_test](#input\_assume\_role\_condition\_test) | Name of the [IAM condition operator](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html) to evaluate when assuming the role | `string` | `"StringEquals"` | no |
| <a name="input_atomic"></a> [atomic](#input\_atomic) | If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. | `bool` | `false` | no |
| <a name="input_attach_secrets_policy"></a> [attach\_secrets\_policy](#input\_attach\_secrets\_policy) | Attach a policy that will allow the role to get secrets from AWS Secrets Manager or AWS SSM | `bool` | `false` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it does not yet exist. | `bool` | `false` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Whether to create a role | `bool` | `true` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Whether policies should be detached from this role when destroying | `bool` | `true` | no |
| <a name="input_helm_chart_values"></a> [helm\_chart\_values](#input\_helm\_chart\_values) | n/a | `any` | n/a | yes |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum CLI/API session duration in seconds between 3600 and 43200 | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the helm deployment | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to install the release into. | `string` | `"default"` | no |
| <a name="input_oidc_providers"></a> [oidc\_providers](#input\_oidc\_providers) | Map of OIDC providers where each provider map should contain the `provider`, `provider_arn`, and `namespace_service_accounts` | `any` | `{}` | no |
| <a name="input_policy_name_prefix"></a> [policy\_name\_prefix](#input\_policy\_name\_prefix) | IAM policy name prefix | `string` | `"AxetraderEKS_"` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | IAM Role description | `string` | `null` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of IAM role | `string` | `null` | no |
| <a name="input_role_name_prefix"></a> [role\_name\_prefix](#input\_role\_name\_prefix) | IAM role name prefix | `string` | `null` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | Path of IAM role | `string` | `"/"` | no |
| <a name="input_role_permissions_boundary_arn"></a> [role\_permissions\_boundary\_arn](#input\_role\_permissions\_boundary\_arn) | Permissions boundary ARN to use for IAM role | `string` | `null` | no |
| <a name="input_role_policy_arns"></a> [role\_policy\_arns](#input\_role\_policy\_arns) | ARNs of any policies to attach to the IAM role | `set(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add the the IAM role | `map(any)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | n/a | `any` | n/a | yes |
| <a name="input_wait"></a> [wait](#input\_wait) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_release_id"></a> [helm\_release\_id](#output\_helm\_release\_id) | n/a |
| <a name="output_helm_release_name"></a> [helm\_release\_name](#output\_helm\_release\_name) | n/a |
| <a name="output_helm_release_namespace"></a> [helm\_release\_namespace](#output\_helm\_release\_namespace) | n/a |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM role |
<!-- END_TF_DOCS -->