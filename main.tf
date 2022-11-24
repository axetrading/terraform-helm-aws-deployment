locals {
  helm_chart_values = flatten([
    for k, v in var.helm_chart_values : {
      name  = k
      value = v
    }
  ])
}

resource "helm_release" "main" {
  name             = var.name
  chart            = "${path.module}/helm/axetrading-api"
  atomic           = var.atomic
  create_namespace = var.create_namespace
  namespace        = var.namespace
  timeout          = var.timeout
  wait             = var.wait

  values = var.additional_value_files

  dynamic "set" {
    for_each = local.helm_chart_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  dynamic "set" {
    for_each = var.create_role ? [aws_iam_role.this[0].arn] : []
    content {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = set.value
      type  = "string"
    }

  }
}
 