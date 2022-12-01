variable "atomic" {
  type        = bool
  description = "If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used."
  default     = false
}
variable "create_namespace" {
  type        = bool
  description = "Create the namespace if it does not yet exist."
  default     = false
}
variable "name" {
  type        = string
  description = "Name of the helm deployment"
}
variable "namespace" {
  type        = string
  description = "The namespace to install the release into."
  default     = "default"
}
variable "timeout" {
  default     = 150
  type        = number
  description = "Time that terraform is waiting for a helm release to create resources"
}
variable "wait" {
  type    = bool
  default = true
}

variable "create_role" {
  description = "Whether to create a role"
  type        = bool
  default     = true
}

variable "role_name" {
  description = "Name of IAM role"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "role_permissions_boundary_arn" {
  description = "Permissions boundary ARN to use for IAM role"
  type        = string
  default     = null
}

variable "role_description" {
  description = "IAM Role description"
  type        = string
  default     = null
}

variable "role_name_prefix" {
  description = "IAM role name prefix"
  type        = string
  default     = null
}

variable "policy_name_prefix" {
  description = "IAM policy name prefix"
  type        = string
  default     = "eks-policy"
}

variable "role_policy_arns" {
  description = "ARNs of any policies to attach to the IAM role"
  type        = set(string)
  default     = []
}

variable "oidc_providers" {
  description = "Map of OIDC providers where each provider map should contain the `provider`, `provider_arn`, and `namespace_service_accounts`"
  type        = any
  default     = {}
}

variable "tags" {
  description = "A map of tags to add the the IAM role"
  type        = map(any)
  default     = {}
}

variable "force_detach_policies" {
  description = "Whether policies should be detached from this role when destroying"
  type        = bool
  default     = true
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = null
}

variable "assume_role_condition_test" {
  description = "Name of the [IAM condition operator](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html) to evaluate when assuming the role"
  type        = string
  default     = "StringEquals"
}

variable "attach_secrets_policy" {
  type        = bool
  description = "Attach a policy that will allow the role to get secrets from AWS Secrets Manager or AWS SSM"
  default     = true
}

variable "additional_value_files" {
  type        = list(any)
  description = "A list of additional value files. It will work in the same way as helm -f value1.yaml -f value2.yaml"
  default     = []
}

variable "role_arn" {
  type        = string
  description = "Existing role ARN"
  default     = null
}

variable "image_repository" {
  type        = string
  description = "Kubernetes Deploymet image for pod's container"
}

variable "image_pull_policy" {
  type        = string
  description = "The imagePullPolicy for a container and the tag of the image affect when the kubelet attempts to pull (download) the specified image."
  default     = "IfNotPresent"
}

variable "image_tag" {
  type        = string
  description = "Kubernetes Deployment image tag"
}

variable "create_service_account" {
  type        = bool
  description = "Whether to create a service account for Kubernetes Deployment"
  default     = true
}

variable "service_type" {
  type        = string
  description = "Kubernetes ServiceTypes allow you to specify what kind of Service you want."
  default     = "ClusterIP"
}

variable "service_port" {
  type        = number
  description = "Kubernetes Service Port"
  default     = 80
}

variable "service_app_port" {
  type        = number
  description = "Kubernetes Container Port"
  default     = 80
}

variable "ingress_enabled" {
  type        = bool
  description = "Whether to create or skip the creation of Kubernetes Ingress for your deployment"
  default     = false
}

variable "ingress_host" {
  type        = string
  description = "Kubernetes Ingress Host"
  default     = null
}

variable "ingress_path" {
  type        = string
  description = "Kubernetes Ingress Path"
  default     = "/"
}

variable "ingress_path_type" {
  type        = string
  description = "Each path in an Ingress is required to have a corresponding path type. Paths that do not include an explicit pathType will fail validation"
  default     = "Prefix"
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the target group with which to register targets - this is used by the targetGroupBinding CRD"
  default     = null
}

variable "target_group_port" {
  type        = number
  description = "AWS Target Group port"
  default     = 80
}

variable "autoscaling_enabled" {
  type        = bool
  description = "When this is set to true, the deployment will include the horizontalPodAutoscaler resource."
  default     = false
}

variable "min_replicas" {
  type        = number
  description = "The minimim number of replicas that will be used by the HPA resource"
  default     = 1
}

variable "max_replicas" {
  type        = number
  description = "The maximum number of replicas that will be used by the HPA resource"
  default     = 1
}

variable "target_cpu_utilization" {
  type        = number
  description = "Target CPU utilization in percentage. "
  default     = 80
}

variable "target_memory_utilization" {
  type        = number
  description = "Target Memory utilization in percentage"
  default     = 80
}

variable "secrets" {
  type        = list(any)
  description = "A list of AWS Secret Manager Secrets that will be mounted as volumes on your containers"
  default     = null
}

variable "health_check_type" {
  type        = string
  description = "Readiness Probe health check type : Valid values: http or tcp"
  default     = "http"
}
