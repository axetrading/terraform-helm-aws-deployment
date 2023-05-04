resource "helm_release" "main" {
  name             = var.name
  chart            = "${path.module}/helm/axetrading-api"
  atomic           = var.atomic
  create_namespace = var.create_namespace
  namespace        = var.namespace
  timeout          = var.timeout
  wait             = var.wait

  values = [
    templatefile("${path.module}/helm/axetrading-api/values.yaml.tpl", {
      imageRepository         = var.image_repository
      imagePullPolicy         = var.image_pull_policy
      autoscaling             = var.autoscaling
      awsSecrets              = var.secrets
      createServiceAccount    = var.create_service_account
      fullNameOverride        = var.name
      imageTag                = var.image_tag
      ingressEnabled          = var.ingress_enabled
      ingressHost             = var.ingress_host
      ingressPath             = var.ingress_path
      ingressPathType         = var.ingress_path_type
      logFetcherEnabled       = var.log_fetcher_enabled
      logFetcherImage         = var.log_fetcher_enabled ? var.log_fetcher_image : ""
      logFetcherLogsPath      = var.log_fetcher_enabled ? var.log_fetcher_logs_path : ""
      maxReplicas             = var.max_replicas
      minReplicas             = var.min_replicas
      readinessCheckType      = var.health_check_type
      replicaSetCount         = var.replica_set
      resources               = var.resources
      serviceAppPort          = var.service_app_port
      servicePort             = var.service_port
      serviceType             = var.service_type
      targetCPUUtilization    = var.target_cpu_utilization
      targetGroupARN          = var.target_group_arn
      targetGroupPort         = var.target_group_port
      targetMemoryUtilization = var.target_memory_utilization
      }
    )
  ]

  #dynamic "set" {
  #  for_each = local.helm_chart_values
  #  content {
  #    name  = set.value.name
  #    value = set.value.value
  #  }
  #}

  dynamic "set" {
    for_each = var.create_role && var.create_service_account ? [aws_iam_role.this[0].arn] : [var.role_arn]
    content {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = set.value
      type  = "string"
    }
  }
}
 