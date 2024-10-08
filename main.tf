
locals {
  values = [
    var.prometheus_rule_enabled ? file(var.prometheus_rules_file_path) : null,
    templatefile("${path.module}/helm/axetrading-api/values.yaml.tpl", {
      imageRepository               = var.image_repository
      imagePullPolicy               = var.image_pull_policy
      additionalPorts               = var.additional_ports
      additionalTargetGroupBindings = var.additional_target_group_bindings
      autoscaling                   = var.autoscaling
      awsSecrets                    = var.secrets
      createServiceAccount          = var.create_service_account
      fullNameOverride              = var.name
      extraVolumes                  = var.extra_volumes
      healthCheckExecCommands       = var.health_check_exec_commands
      healthCheckPath               = var.health_check_path
      imageTag                      = var.image_tag
      ingressEnabled                = var.ingress_enabled
      ingressHost                   = var.ingress_host
      ingressPath                   = var.ingress_path
      ingressPathType               = var.ingress_path_type
      initialDelaySeconds           = var.health_check_initial_delay_seconds
      logFetcherLogsPath            = var.log_fetcher_enabled ? var.log_fetcher_logs_path : ""
      nodeLabelKey                  = length(var.node_labels) > 0 ? keys(var.node_labels)[0] : ""
      nodeLabelValues               = length(var.node_labels) > 0 ? values(var.node_labels)[0] : []
      readinessCheckType            = var.health_check_type
      replicaSetCount               = var.replica_set
      resources                     = var.resources
      serviceAppPort                = var.service_app_port
      serviceMonitors               = var.service_monitors
      serviceMonitorsEnabled        = var.service_monitor_enabled
      servicePort                   = var.service_port
      serviceType                   = var.service_type
      targetCPUUtilization          = var.target_cpu_utilization
      targetGroupARN                = var.target_group_arn
      targetGroupPort               = var.target_group_port
      targetMemoryUtilization       = var.target_memory_utilization
      }
    )
  ]
  deployment_values = compact(local.values)
}
resource "helm_release" "main" {
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
    for_each = var.statefulset_enabled ? [true] : []
    content {
      name  = "podManagementPolicy"
      value = var.pod_management_policy
      type  = "string"
    }
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
    for_each = var.log_fetcher_enabled ? [true] : []
    content {
      name  = "logFetcher.enabled"
      value = set.value
      type  = "string"
    }
  }

  dynamic "set" {
    for_each = var.log_fetcher_enabled ? [true] : []
    content {
      name  = "logFetcher.image"
      value = var.log_fetcher_image
      type  = "string"
    }
  }

  dynamic "set" {
    for_each = var.log_fetcher_enabled ? [true] : []
    content {
      name  = "logFetcher.logsPath"
      value = var.log_fetcher_logs_path
      type  = "string"
    }
  }

  dynamic "set" {
    for_each = var.log_fetcher_enabled ? [true] : []
    content {
      name  = "logFetcher.resources.requests.cpu"
      value = var.log_fetcher_resources_cpu
      type  = "string"
    }
  }

  dynamic "set" {
    for_each = var.log_fetcher_enabled ? [true] : []
    content {
      name  = "logFetcher.resources.requests.memory"
      value = var.log_fetcher_resources_memory
      type  = "string"
    }
  }

  dynamic "set" {
    for_each = var.log_fetcher_enabled ? [true] : []
    content {
      name  = "logFetcher.resources.limits.memory"
      value = var.log_fetcher_resources_memory
      type  = "string"
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
    name  = "volumeProvisioner.enabled"
    value = var.volume_provisioner_enabled
  }

  dynamic "set" {
    for_each = var.volume_provisioner_enabled ? [true] : []
    content {
      name  = "volumeProvisioner.storage.volumeName"
      value = var.volume_provisioner_volume_name
    }

  }

  dynamic "set" {
    for_each = var.volume_provisioner_enabled ? [true] : []
    content {
      name  = "volumeProvisioner.storage.dynamic"
      value = var.volume_provisioner_dynamic_provisioning
    }
  }

  dynamic "set" {
    for_each = var.volume_provisioner_enabled ? [true] : []
    content {
      name  = "volumeProvisioner.storage.storageClassName"
      value = var.volume_provisioner_storage_class_name
    }
  }

  dynamic "set" {
    for_each = var.volume_provisioner_enabled ? [true] : []
    content {
      name  = "volumeProvisioner.storage.volumeHandle"
      value = var.volume_provisioner_volume_handle
    }
  }

  dynamic "set" {
    for_each = var.volume_provisioner_enabled ? [true] : []
    content {
      name  = "volumeProvisioner.storage.mountPath"
      value = var.volume_provisioner_mount_path
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
    for_each = var.timezone != null ? [true] : []
    content {
      name  = "timezone"
      value = var.timezone
    }
  }

  dynamic "set" {
    for_each = var.priority_class_name != null ? [true] : []
    content {
      name  = "priorityClassName"
      value = var.priority_class_name
    }
  }
}