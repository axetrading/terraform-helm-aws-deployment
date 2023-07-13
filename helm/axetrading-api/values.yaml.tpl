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
  %{~ endif ~}
  %{~ if readinessCheckType == "tcp" ~}
  httpCheck:
    enabled: false
  tpcCheck:
    enabled: true
  %{~ endif ~}

logFetcher:
  enabled: ${logFetcherEnabled}
  image: ${logFetcherImage}
  imagePullPolicy: IfNotPresent
  logsPath: ${logFetcherLogsPath}

healthcheck:
  path: ${healthCheckPath}

statsd:
  enabled: false

nodeSelector: {}

tolerations: []

affinity: {}

prometheusRule: {}
  enabled: false
  additionalLabels: {}
  rules: []