replicaCount: ${replicaSetCount}

image:
  repository: ""
  pullPolicy: ${imagePullPolicy}
  tag: ""

strategy:
  type: ""
podManagementPolicy: ""
imagePullSecrets: []
nameOverride: ""
fullnameOverride: ${fullNameOverride}

serviceAccount:
  create: ${createServiceAccount}
  annotations: {}
  name: ""

podAnnotations: {}

podSecurityContext: {}

securityContext: {}
service:
  type: ${serviceType}
  port: ${servicePort}
  appport: ${serviceAppPort}
  %{~ if additionalPorts != null ~}
  additionalPorts: 
    %{~ for port in additionalPorts ~}
    - name: svc-${port}
      port: ${port}
    %{~ endfor ~}
  %{~ endif ~}

ingress:
  enabled: ${ingressEnabled}
  className: ""
  annotations: {}
  hosts:
    %{~ if ingressEnabled ~}
    - host: ${ingressHost}
      paths:
        - path: ${ingressPath}
          pathType: ${ingressPathType}
    %{~ endif ~}
  tls: []

initialDelaySeconds: ${initialDelaySeconds}

resources:
   limits:
     memory: ${resources.memory}
   requests:
     cpu: ${resources.cpu}
     memory: ${resources.memory}
targetGroupBinding:
  %{~ if targetGroupARN != null ~} 
  enabled: true
  port: ${targetGroupPort}
  targetGroupARN: ${targetGroupARN}
  %{~ endif ~}
  %{~ if targetGroupARN == null ~}
  enabled: false
  %{~ endif ~}

additionalTargetGroupBindings:
  enabled: %{ if additionalTargetGroupBindings != null && length(additionalTargetGroupBindings) > 0 }true%{~ else }false%{~ endif }
  mappings: 
  %{~ for binding in additionalTargetGroupBindings ~}
    - port: ${binding.port}
      targetGroupARN: ${binding.targetGroupARN}
      name: ${binding.name}
  %{~ endfor ~}


autoscaling:
  %{~ if autoscaling != null ~}
  enabled: true
  minReplicas: ${autoscaling.min_replicas}
  maxReplicas: ${autoscaling.max_replicas}
  targetCPUUtilizationPercentage: ${autoscaling.target_cpu_utilization}
  targetMemoryUtilizationPercentage: ${autoscaling.target_memory_utilization}
  %{~ endif ~}
  %{~ if autoscaling == null ~}
  enabled: false
  %{~ endif ~}

secretsStore:
  %{~ if awsSecrets != null ~}
  enabled: true
  provider: aws
  awsSecrets:
    %{~ for secret in awsSecrets ~}
    - ${secret}
    %{~ endfor ~}
  %{~ endif ~}
  %{~ if awsSecrets == null ~}
  enabled: false
  %{~ endif ~}

readiness:
  %{~ if readinessCheckType == "http" ~}
  httpCheck:
    enabled: true
  tpcCheck:
    enabled: false
  execCmd:
    enabled: false
  %{~ endif ~}
  %{~ if readinessCheckType == "tcp" ~}
  httpCheck:
    enabled: false
  tpcCheck:
    enabled: true
  execCmd:
    enabled: false
  %{~ endif ~}
  %{~ if readinessCheckType == "exec" ~}
  httpCheck:
    enabled: false
  tpcCheck:
    enabled: false
  execCmd:
    enabled: true
  %{~ endif ~}

logFetcher:
  enabled: ${logFetcherEnabled}
  image: ${logFetcherImage}
  imagePullPolicy: IfNotPresent
  logsPath: ${logFetcherLogsPath}
  persistence: false

fileSync:
  enabled: false
  mountPath: ""
  source: ""
  destination: ""
  imagePullPolicy: IfNotPresent
  image: ""

healthcheck:
  path: ${healthCheckPath}
  %{~ if readinessCheckType == "exec" ~}
  execCommands: 
    %{~ for command in healthCheckExecCommands ~}
    - ${command}
    %{~ endfor ~}
  %{~ endif ~}

statsd:
  enabled: false

nodeSelector: {}

tolerations: []

%{ if nodeLabelKey != "" ~}
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: ${nodeLabelKey}
          operator: In
          values: 
          %{ for value in nodeLabelValues ~}
          - ${value}
          %{ endfor ~}
%{ endif ~}

prometheusRule:
  enabled: false
  additionalLabels: {}
  # rules: []

statefulset:
  enabled: false

persistence:
  enabled: false
  accessMode: ReadWriteMany
  storageSize: 2Gi
  storageClassName: ""
  mountPath: ""
  efsFileSystemId: ""
  reclaimPolicy: retain

storageClass:
  create: false
  name: ""

container_commands:
  args: []

serviceMonitor:
  enabled: %{ if serviceMonitorsEnabled && length(serviceMonitors) > 0 }true%{~ else }false%{~ endif }
  namespace: monitoring
  moduleOpts: ""
  targets:
  %{~ for target in serviceMonitors ~}
    - name: ${target.name}
      port: ${target.port}
      metricsPath: ${target.metricsPath}
  %{~ endfor ~}

extraVolumes:
  enabled: %{ if extraVolumes != null && length(extraVolumes) > 0 }true%{~ else }false%{~ endif }
  volumes: 
  %{~ for volume in extraVolumes ~}
    - name: ${volume.name}
      claimName: ${volume.pvc_claim_name}
      mountPath: ${volume.mount_path}
  %{~ endfor ~}


volumeProvisioner:
  enabled: false
  storage:
  # Enable dynamic provisioning
    dynamic: false 
  # Name of the StorageClass to be created
    storageClassName: efs-sc
  # EFS FileSystem ID for dynamic provisioning
    volumeHandle: "" 
  # Directory permissions for dynamic provisioning
    volumeName: ""
    mounthPath: ""
    directoryPerms: "700" 
  # GIDRange for dynamic provisioning
    gidRangeStart: "1000"
    gidRangeEnd: "2000"
    pvc:
      accessModes: [ "ReadWriteMany" ]
      size: "2Gi"
    pv:
      size: "5Gi"
      accessModes: [ "ReadWriteMany" ]
      reclaimPolicy: Retain
