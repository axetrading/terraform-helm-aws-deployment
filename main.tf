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
  chart            = "./helm/axetrading-api"
  atomic           = var.atomic
  create_namespace = var.create_namespace
  namespace        = var.namespace
  timeout          = var.timeout
  wait             = var.wait

  values = [
    file("${path.module}/helm/axetrading-api/values.yaml")
  ]

  dynamic "set" {
    for_each = local.helm_chart_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

}
 