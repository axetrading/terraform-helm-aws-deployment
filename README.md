# terraform-helm-release
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.36 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.36 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.9.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_short-name"></a> [short-name](#module\_short-name) | axetrading/short-name/null | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.amazoneks_efs_csi_driver_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.amazoneks_efs_csi_driver_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.main](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_iam_policy_document.amazoneks_efs_csi_driver_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [helm_template.main](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/data-sources/template) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_java_opts"></a> [additional\_java\_opts](#input\_additional\_java\_opts) | Additional java options for JVM | `string` | `""` | no |
| <a name="input_additional_ports"></a> [additional\_ports](#input\_additional\_ports) | A list of additional ports to expose on the container and service | `list(any)` | `null` | no |
| <a name="input_additional_target_group_bindings"></a> [additional\_target\_group\_bindings](#input\_additional\_target\_group\_bindings) | List of additional target group bindings | <pre>list(object({<br>    name           = string<br>    targetGroupARN = string<br>    port           = number<br>  }))</pre> | `[]` | no |
| <a name="input_additional_value_files"></a> [additional\_value\_files](#input\_additional\_value\_files) | A list of additional value files. It will work in the same way as helm -f value1.yaml -f value2.yaml | `list(any)` | `[]` | no |
| <a name="input_assume_role_condition_test"></a> [assume\_role\_condition\_test](#input\_assume\_role\_condition\_test) | Name of the [IAM condition operator](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html) to evaluate when assuming the role | `string` | `"StringEquals"` | no |
| <a name="input_atomic"></a> [atomic](#input\_atomic) | If set, the installation process purges the chart on failure. The wait flag will be set automatically if atomic is used. | `bool` | `false` | no |
| <a name="input_attach_amazoneks_efs_csi_driver_policy"></a> [attach\_amazoneks\_efs\_csi\_driver\_policy](#input\_attach\_amazoneks\_efs\_csi\_driver\_policy) | Attach a policy that allows the CSI driver’s service account to make calls to AWS APIs on your behalf | `bool` | `false` | no |
| <a name="input_attach_secrets_policy"></a> [attach\_secrets\_policy](#input\_attach\_secrets\_policy) | Attach a policy that will allow the role to get secrets from AWS Secrets Manager or AWS SSM | `bool` | `true` | no |
| <a name="input_autoscaling"></a> [autoscaling](#input\_autoscaling) | "A map of autoscaling configuration, containing keys 'min\_replicas', <br>  'max\_replicas', 'target\_cpu\_utilization' and 'target\_memory\_utilization'. | <pre>object({<br>    min_replicas              = number<br>    max_replicas              = number<br>    target_cpu_utilization    = optional(number, 75)<br>    target_memory_utilization = optional(number, 75)<br>  })</pre> | `null` | no |
| <a name="input_container_commands_args"></a> [container\_commands\_args](#input\_container\_commands\_args) | A list of args for container image at startup | `list(any)` | `[]` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | If set, Terraform will create the namespace if it does not yet exist. | `bool` | `false` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Whether to create a role | `bool` | `true` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | Whether to create a service account for Kubernetes Deployment | `bool` | `true` | no |
| <a name="input_create_storage_class"></a> [create\_storage\_class](#input\_create\_storage\_class) | Whether to create storage class | `bool` | `false` | no |
| <a name="input_deployment_strategy_type"></a> [deployment\_strategy\_type](#input\_deployment\_strategy\_type) | Deployment strategy type. Valid values: RollingUpdate, Recreate | `string` | `"RollingUpdate"` | no |
| <a name="input_efs_filesystem_id"></a> [efs\_filesystem\_id](#input\_efs\_filesystem\_id) | EFS File System Id | `string` | `""` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Whether policies should be detached from this role when destroying | `bool` | `true` | no |
| <a name="input_health_check_exec_commands"></a> [health\_check\_exec\_commands](#input\_health\_check\_exec\_commands) | Readiness Probe health check exec command | `list(any)` | `[]` | no |
| <a name="input_health_check_initial_delay_seconds"></a> [health\_check\_initial\_delay\_seconds](#input\_health\_check\_initial\_delay\_seconds) | Number of seconds after the container has started before liveness probes are initiated. | `number` | `30` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Readiness Probe health check path | `string` | `"/healthcheck"` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | Readiness Probe health check type : Valid values: http or tcp or exec | `string` | `"http"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | The imagePullPolicy for a container and the tag of the image affect when the kubelet attempts to pull (download) the specified image. | `string` | `"IfNotPresent"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Kubernetes Deployment image for pod's container | `string` | n/a | yes |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Kubernetes Deployment image tag | `string` | n/a | yes |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | Whether to create or skip the creation of Kubernetes Ingress for your deployment | `bool` | `false` | no |
| <a name="input_ingress_host"></a> [ingress\_host](#input\_ingress\_host) | Kubernetes Ingress Host | `string` | `null` | no |
| <a name="input_ingress_path"></a> [ingress\_path](#input\_ingress\_path) | Kubernetes Ingress Path | `string` | `"/"` | no |
| <a name="input_ingress_path_type"></a> [ingress\_path\_type](#input\_ingress\_path\_type) | Each path in an Ingress is required to have a corresponding path type. Paths that do not include an explicit pathType will fail validation | `string` | `"Prefix"` | no |
| <a name="input_log_fetcher_enabled"></a> [log\_fetcher\_enabled](#input\_log\_fetcher\_enabled) | Whether to enable the log-fetcher sidecar container or not | `bool` | `false` | no |
| <a name="input_log_fetcher_image"></a> [log\_fetcher\_image](#input\_log\_fetcher\_image) | The container image for the log-fetcher sidecar container. | `string` | `""` | no |
| <a name="input_log_fetcher_logs_path"></a> [log\_fetcher\_logs\_path](#input\_log\_fetcher\_logs\_path) | The path on the host where the logs will be stored, to be mounted as a volume for the log-fetcher container. | `string` | `""` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum CLI/API session duration in seconds between 3600 and 43200 | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Helm deployment. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to install the release into. | `string` | `"default"` | no |
| <a name="input_node_labels"></a> [node\_labels](#input\_node\_labels) | Map of node labels for pod scheduling. This map must only contain one key-value pair. | `map(list(string))` | `{}` | no |
| <a name="input_oidc_providers"></a> [oidc\_providers](#input\_oidc\_providers) | Map of OIDC providers where each provider map should contain the `provider`, `provider_arn`, and `namespace_service_accounts` | `any` | `{}` | no |
| <a name="input_persistence_accessMode"></a> [persistence\_accessMode](#input\_persistence\_accessMode) | Accessmode for persistent storage | `string` | `"ReadWriteOnce"` | no |
| <a name="input_persistence_enabled"></a> [persistence\_enabled](#input\_persistence\_enabled) | Whether to create persistent storage | `bool` | `false` | no |
| <a name="input_persistence_mountPath"></a> [persistence\_mountPath](#input\_persistence\_mountPath) | Mount Path for Persistent Storage on Pod | `string` | `""` | no |
| <a name="input_persistence_storageSize"></a> [persistence\_storageSize](#input\_persistence\_storageSize) | Storage size for persistent storage | `string` | `"2Gi"` | no |
| <a name="input_policy_name_prefix"></a> [policy\_name\_prefix](#input\_policy\_name\_prefix) | IAM policy name prefix | `string` | `"eks-policy"` | no |
| <a name="input_prometheus_rule_enabled"></a> [prometheus\_rule\_enabled](#input\_prometheus\_rule\_enabled) | Whether to create prometheus rule | `bool` | `false` | no |
| <a name="input_prometheus_rules_file_path"></a> [prometheus\_rules\_file\_path](#input\_prometheus\_rules\_file\_path) | Prometheus rules file path | `string` | `"prometheus-rules.yml"` | no |
| <a name="input_replica_set"></a> [replica\_set](#input\_replica\_set) | The number of replica set for the helm deployment | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | "A map of resource for the main app container, containing keys 'cpu' and 'memory'. <br>  This is following the Kubernetes resource best practices, which states that no limits for the CPU should be set and the memory limit should always be equal with memory request.<br>  In this way, we can prevent OOMKill (talk with the devs about cpu/memory requirements)." | <pre>object({<br>    memory = string<br>    cpu    = string<br>  })</pre> | <pre>{<br>  "cpu": "250m",<br>  "memory": "512Mi"<br>}</pre> | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | Existing role ARN | `string` | `null` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | IAM Role description | `string` | `null` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of IAM role | `string` | `null` | no |
| <a name="input_role_name_prefix"></a> [role\_name\_prefix](#input\_role\_name\_prefix) | IAM role name prefix | `string` | `null` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | Path of IAM role | `string` | `"/"` | no |
| <a name="input_role_permissions_boundary_arn"></a> [role\_permissions\_boundary\_arn](#input\_role\_permissions\_boundary\_arn) | Permissions boundary ARN to use for IAM role | `string` | `null` | no |
| <a name="input_role_policy_arns"></a> [role\_policy\_arns](#input\_role\_policy\_arns) | ARNs of any policies to attach to the IAM role | `set(string)` | `[]` | no |
| <a name="input_safe_to_evict_enabled"></a> [safe\_to\_evict\_enabled](#input\_safe\_to\_evict\_enabled) | Whether to enable the safe-to-evict annotation for the pod - this is required by Cluster Autoscaler to be able to evict pods when scaling down | `bool` | `true` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | A list of AWS Secret Manager Secrets that will be mounted as volumes on your containers | `list(any)` | `null` | no |
| <a name="input_service_app_port"></a> [service\_app\_port](#input\_service\_app\_port) | Kubernetes Container Port | `number` | `80` | no |
| <a name="input_service_monitor_enabled"></a> [service\_monitor\_enabled](#input\_service\_monitor\_enabled) | Whether to create service monitor resource | `bool` | `false` | no |
| <a name="input_service_monitor_port"></a> [service\_monitor\_port](#input\_service\_monitor\_port) | Port for service monitor | `string` | `"svc-9779"` | no |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | Kubernetes Service Port | `number` | `80` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | Kubernetes ServiceTypes allow you to specify what kind of Service you want. | `string` | `"ClusterIP"` | no |
| <a name="input_statefulset_enabled"></a> [statefulset\_enabled](#input\_statefulset\_enabled) | Whether to create statefulset | `bool` | `false` | no |
| <a name="input_statsd_enabled"></a> [statsd\_enabled](#input\_statsd\_enabled) | Whether to create statsd host environment variables | `bool` | `false` | no |
| <a name="input_storage_class_name"></a> [storage\_class\_name](#input\_storage\_class\_name) | Name of the storage class | `string` | `"efs-sc"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add the the IAM role | `map(any)` | `{}` | no |
| <a name="input_target_cpu_utilization"></a> [target\_cpu\_utilization](#input\_target\_cpu\_utilization) | Target CPU utilization in percentage. | `number` | `80` | no |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | The ARN of the target group with which to register targets - this is used by the targetGroupBinding CRD | `string` | `null` | no |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | AWS Target Group port | `number` | `80` | no |
| <a name="input_target_memory_utilization"></a> [target\_memory\_utilization](#input\_target\_memory\_utilization) | Target Memory utilization in percentage | `number` | `80` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The time, in seconds, that Terraform will wait for a Helm release to create resources. | `number` | `150` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | If set, Terraform will wait for the Helm release to complete before continuing. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_manifests_out"></a> [helm\_manifests\_out](#output\_helm\_manifests\_out) | Helm Release Manifest |
| <a name="output_helm_release_id"></a> [helm\_release\_id](#output\_helm\_release\_id) | Helm Release ID |
| <a name="output_helm_release_name"></a> [helm\_release\_name](#output\_helm\_release\_name) | Helm Release Name |
| <a name="output_helm_release_namespace"></a> [helm\_release\_namespace](#output\_helm\_release\_namespace) | Helm Release Namespace |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM role |
<!-- END_TF_DOCS -->