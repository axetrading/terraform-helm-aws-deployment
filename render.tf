data "helm_template" "main" {
  name             = var.name
  chart            = "${path.module}/helm/axetrading-api"
  atomic           = var.atomic
  create_namespace = var.create_namespace
  namespace        = var.namespace
  timeout          = var.timeout
  wait             = var.wait

  values = local.deployment_values
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


}