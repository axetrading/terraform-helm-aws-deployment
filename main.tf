locals {
  #helm_chart_values = flatten([
  #  for k, v in var.helm_chart_values : {
  #    name  = k
  #    value = v
  #  }
  #])
}

resource "helm_release" "main" {
  name             = var.name
  chart            = "${path.module}/helm/axetrading-api"
  atomic           = var.atomic
  create_namespace = var.create_namespace
  namespace        = var.namespace
  timeout          = var.timeout
  wait             = var.wait

  values = [
    templatefile("${path.module}/helm/axetrading-api/values.yaml", {
      imageRepository         = var.image_repository
      imagePullPolicy         = var.image_pull_policy
      imageTag                = var.image_tag
      fullNameOverride        = var.name
      createServiceAccount    = var.create_service_account
      serviceType             = var.service_type
      servicePort             = var.service_port
      serviceAppPort          = var.service_app_port
      ingressEnabled          = var.ingress_enabled
      ingressHost             = var.ingress_host
      ingressPath             = var.ingress_path
      ingressPathType         = var.ingress_path_type
      targetGroupARN          = var.target_group_arn
      targetGroupPort         = var.target_group_port
      autoscalingEnabled      = var.autoscaling_enabled
      minReplicas             = var.min_replicas
      maxReplicas             = var.max_replicas
      targetCPUUtilization    = var.target_cpu_utilization
      targetMemoryUtilization = var.target_memory_utilization
      awsSecrets              = var.secrets
      readinessCheckType      = var.health_check_type
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
 