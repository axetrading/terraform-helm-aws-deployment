replicaCount: ${replicaSetCount}

image:
  repository: ""
  pullPolicy: ${imagePullPolicy}
  tag: ""

strategy:
  type: ""
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
  enabled: true
  accessMode: ReadWriteMany
  storageSize: 2Gi
  storageClass: efs
  storageClassName: ""
  mountPath: ""

storageClass:
  create: false
  name: ""

efsProvisioner:
  efsFileSystemId: ""
  reclaimPolicy: retain

container_commands:
  args: []
