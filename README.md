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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_short-name"></a> [short-name](#module\_short-name) | axetrading/short-name/null | 1.0.0 |

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
| <a name="input_attach_secrets_policy"></a> [attach\_secrets\_policy](#input\_attach\_secrets\_policy) | Attach a policy that will allow the role to get secrets from AWS Secrets Manager or AWS SSM | `bool` | `true` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | When this is set to true, the deployment will include the horizontalPodAutoscaler resource. | `bool` | `false` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it does not yet exist. | `bool` | `false` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Whether to create a role | `bool` | `true` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | Whether to create a service account for Kubernetes Deployment | `bool` | `true` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Whether policies should be detached from this role when destroying | `bool` | `true` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | Readiness Probe health check type : Valid values: http or tcp | `string` | `"http"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | The imagePullPolicy for a container and the tag of the image affect when the kubelet attempts to pull (download) the specified image. | `string` | `"IfNotPresent"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Kubernetes Deploymet image for pod's container | `string` | n/a | yes |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Kubernetes Deployment image tag | `string` | n/a | yes |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | Whether to create or skip the creation of Kubernetes Ingress for your deployment | `bool` | `false` | no |
| <a name="input_ingress_host"></a> [ingress\_host](#input\_ingress\_host) | Kubernetes Ingress Host | `string` | `null` | no |
| <a name="input_ingress_path"></a> [ingress\_path](#input\_ingress\_path) | Kubernetes Ingress Path | `string` | `"/"` | no |
| <a name="input_ingress_path_type"></a> [ingress\_path\_type](#input\_ingress\_path\_type) | Each path in an Ingress is required to have a corresponding path type. Paths that do not include an explicit pathType will fail validation | `string` | `"Prefix"` | no |
| <a name="input_max_replicas"></a> [max\_replicas](#input\_max\_replicas) | The maximum number of replicas that will be used by the HPA resource | `number` | `1` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum CLI/API session duration in seconds between 3600 and 43200 | `number` | `null` | no |
| <a name="input_min_replicas"></a> [min\_replicas](#input\_min\_replicas) | The minimim number of replicas that will be used by the HPA resource | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the helm deployment | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to install the release into. | `string` | `"default"` | no |
| <a name="input_oidc_providers"></a> [oidc\_providers](#input\_oidc\_providers) | Map of OIDC providers where each provider map should contain the `provider`, `provider_arn`, and `namespace_service_accounts` | `any` | `{}` | no |
| <a name="input_policy_name_prefix"></a> [policy\_name\_prefix](#input\_policy\_name\_prefix) | IAM policy name prefix | `string` | `"eks-policy"` | no |
| <a name="input_replica_set"></a> [replica\_set](#input\_replica\_set) | The number of replica set for the helm deployment | `number` | `1` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | Existing role ARN | `string` | `null` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | IAM Role description | `string` | `null` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of IAM role | `string` | `null` | no |
| <a name="input_role_name_prefix"></a> [role\_name\_prefix](#input\_role\_name\_prefix) | IAM role name prefix | `string` | `null` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | Path of IAM role | `string` | `"/"` | no |
| <a name="input_role_permissions_boundary_arn"></a> [role\_permissions\_boundary\_arn](#input\_role\_permissions\_boundary\_arn) | Permissions boundary ARN to use for IAM role | `string` | `null` | no |
| <a name="input_role_policy_arns"></a> [role\_policy\_arns](#input\_role\_policy\_arns) | ARNs of any policies to attach to the IAM role | `set(string)` | `[]` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | A list of AWS Secret Manager Secrets that will be mounted as volumes on your containers | `list(any)` | `null` | no |
| <a name="input_service_app_port"></a> [service\_app\_port](#input\_service\_app\_port) | Kubernetes Container Port | `number` | `80` | no |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | Kubernetes Service Port | `number` | `80` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | Kubernetes ServiceTypes allow you to specify what kind of Service you want. | `string` | `"ClusterIP"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add the the IAM role | `map(any)` | `{}` | no |
| <a name="input_target_cpu_utilization"></a> [target\_cpu\_utilization](#input\_target\_cpu\_utilization) | Target CPU utilization in percentage. | `number` | `80` | no |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | The ARN of the target group with which to register targets - this is used by the targetGroupBinding CRD | `string` | `null` | no |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | AWS Target Group port | `number` | `80` | no |
| <a name="input_target_memory_utilization"></a> [target\_memory\_utilization](#input\_target\_memory\_utilization) | Target Memory utilization in percentage | `number` | `80` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time that terraform is waiting for a helm release to create resources | `number` | `150` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | n/a | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_release_id"></a> [helm\_release\_id](#output\_helm\_release\_id) | Helm Release ID |
| <a name="output_helm_release_name"></a> [helm\_release\_name](#output\_helm\_release\_name) | Helm Release Name |
| <a name="output_helm_release_namespace"></a> [helm\_release\_namespace](#output\_helm\_release\_namespace) | Helm Release Namespace |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM role |
<!-- END_TF_DOCS -->