data "helm_template" "main" {
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
      healthCheckPath         = var.health_check_path
      imageTag                = var.image_tag
      ingressEnabled          = var.ingress_enabled
      ingressHost             = var.ingress_host
      ingressPath             = var.ingress_path
      ingressPathType         = var.ingress_path_type
      initialDelaySeconds     = var.health_check_initial_delay_seconds
      logFetcherEnabled       = var.log_fetcher_enabled
      logFetcherImage         = var.log_fetcher_enabled ? var.log_fetcher_image : ""
      logFetcherLogsPath      = var.log_fetcher_enabled ? var.log_fetcher_logs_path : ""
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
  set {
    name  = "podAnnotations.cluster-autoscaler\\.kubernetes\\.io/safe-to-evict"
    value = var.safe_to_evict_enabled
    type  = "string"
  }

  dynamic "set" {
    for_each = var.create_role && var.create_service_account ? [aws_iam_role.this[0].arn] : [var.role_arn]
    content {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = set.value
      type  = "string"
    }
  }

  set {
    name  = "image.repository"
    value = var.image_repository
    type  = "string"
  }

  set {
    name  = "image.tag"
    value = var.image_tag
    type  = "string"
  }

  set {
    name  = "strategy.type"
    value = var.deployment_strategy_type
    type  = "string"
  }

  dynamic "set" {
    for_each = var.statsd_enabled ? [var.statsd_enabled] : []
    content {
      name  = "statsd.enabled"
      value = set.value
      type  = "string"
    }
  }

  set {
    name  = "prometheusRule.enabled"
    value = var.prometheus_rule_enabled
  }

  dynamic "set" {
    for_each = var.prometheus_rule_enabled ? [var.prometheus_rule_enabled] : []
    content {
      name  = "prometheusRule.rules"
      value = yamlencode(file(var.prometheus_rules_file_path))
    }
  }

}