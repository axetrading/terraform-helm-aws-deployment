replicaCount: 1

image:
  repository: ""
  pullPolicy: "IfNotPresent"
  tag: ""

strategy:
  type: "RollingUpdate"
podManagementPolicy: "OrderedReady"
imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  create: false
  annotations: {}
  name: ""

podAnnotations: {}

podSecurityContext: {}

securityContext: {}
service:
  type: ClusterIP
  port: 80
  appport: 80
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

initialDelaySeconds: 30

resources:
   limits:
     memory: 512Mi
   requests:
     cpu: 100m
     memory: 512Mi

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
  enabled: false
  minReplicas: 1
  maxReplicas: 2
  targetCPUUtilizationPercentage: 75
  targetMemoryUtilizationPercentage: 75

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
  tcpCheck:
    enabled: false
  execCmd:
    enabled: false
  %{~ endif ~}
  %{~ if readinessCheckType == "tcp" ~}
  httpCheck:
    enabled: false
  tcpCheck:
    enabled: true
  execCmd:
    enabled: false
  %{~ endif ~}
  %{~ if readinessCheckType == "exec" ~}
  httpCheck:
    enabled: false
  tcpCheck:
    enabled: false
  execCmd:
    enabled: true
  %{~ endif ~}

logFetcher:
  enabled: false
  image: ""
  imagePullPolicy: IfNotPresent
  logsPath: ""
  persistence:
    enabled: false
  resources:
    limits:
      memory: "128Mi"
    requests:
      memory: "128Mi"
      cpu: "100m"

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

timezone: ""
priorityClassName: ""