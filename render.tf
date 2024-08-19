data "helm_template" "main" {
  count            = var.render_enabled ? 1 : 0
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

  set {
    name  = "statefulset.enabled"
    value = var.statefulset_enabled
  }

  set {
    name  = "persistence.enabled"
    value = var.persistence_enabled
  }

  set {
    name  = "sftp.enabled"
    value = var.persistence_enabled
  }

  set {
    name  = "persistence.accessMode"
    value = var.persistence_access_mode
    type  = "string"
  }

  set {
    name  = "container_commands.args"
    value = "{${join(",", var.container_commands_args)}}"
  }

  set {
    name  = "persistence.storageSize"
    value = var.persistence_storage_size
    type  = "string"
  }

  set {
    name  = "persistence.mountPath"
    value = var.persistence_mount_path
    type  = "string"
  }
  set {
    name  = "sftp.mountPath"
    value = var.sftp_mount_path
    type  = "string"
  }

  dynamic "set" {
    for_each = var.persistence_enabled ? [true] : []
    content {
      name  = "persistence.efsFileSystemId"
      value = var.efs_filesystem_id
      type  = "string"
    }
  }


  dynamic "set" {
    for_each = var.sftp_enabled ? [true] : []
    content {
      name  = "sftp.efsFileSystemId"
      value = var.sftp_efs_filesystem_id
      type  = "string"
    }
  }

  dynamic "set" {
    for_each = var.ingress_enabled ? [var.ingress_enabled] : []
    content {
      name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
      value = "nginx"
      type  = "string"
    }
  }

  dynamic "set" {
    for_each = var.create_storage_class ? [true] : [false]
    content {
      name  = "storageClass.create"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.persistence_enabled ? [var.persistence_enabled] : []
    content {
      name  = "persistence.storageClassName"
      value = var.storage_class_name
    }
  }


  dynamic "set" {
    for_each = var.sftp_enabled ? [true] : []
    content {
      name  = "persistence.storageClassName"
      value = var.sftp_storage_class_name
    }
  }


  dynamic "set" {
    for_each = var.service_monitor_enabled ? [true] : [false]
    content {
      name  = "serviceMonitor.moduleOpts"
      value = var.module_opts
      type  = "string"
    }
  }

  set {
    name  = "volume-provisioner.enabled"
    value = var.volume_provisioner_enabled
  }

  dynamic "set" {
    for_each = var.volume_provisioner_enabled ? [true] : []
    content {
      name  = "volume-provisioner.storage.volumeName"
      value = var.volume_provisioner_volume_name
    }

  }

  dynamic "set" {
    for_each = var.volume_provisioner_enabled ? [true] : []
    content {
      name  = "volume-provisioner.storage.dynamic"
      value = var.volume_provisioner_dynamic_provisioning
    }
  }

  dynamic "set" {
    for_each = var.volume_provisioner_enabled ? [true] : []
    content {
      name  = "volume-provisioner.storage.storageClass"
      value = var.volume_provisioner_storage_class_name
    }
  }

  dynamic "set" {
    for_each = var.volume_provisioner_enabled ? [true] : []
    content {
      name  = "volume-provisioner.storage.volumeHandle"
      value = var.volume_provisioner_volume_handle
    }
  }

  dynamic "set" {
    for_each = var.statefulset_enabled ? [true] : []
    content {
      name  = "podManagementPolicy"
      value = var.pod_management_policy
      type  = "string"
    }
  }
  dynamic "set" {
    for_each = var.filesync_enabled ? [true] : []
    content {
      name  = "fileSync.enabled"
      value = var.filesync_enabled
    }
  }

  dynamic "set" {
    for_each = var.filesync_enabled ? [true] : []
    content {
      name  = "fileSync.image"
      value = var.filesync_image
    }
  }

  dynamic "set" {
    for_each = var.filesync_enabled ? [true] : []
    content {
      name  = "fileSync.mountPath"
      value = var.filesync_mount_path
    }
  }

  dynamic "set" {
    for_each = var.filesync_enabled ? [true] : []
    content {
      name  = "fileSync.source"
      value = var.filesync_source_path
    }
  }

  dynamic "set" {
    for_each = var.filesync_enabled ? [true] : []
    content {
      name  = "fileSync.destination"
      value = var.filesync_destination_path
    }
  }

  dynamic "set" {
    for_each = var.log_fetcher_persistence_enabled ? [true] : []
    content {
      name  = "logFetcher.persistence.enabled"
      value = set.value
      type  = "string"
    }
  }

}