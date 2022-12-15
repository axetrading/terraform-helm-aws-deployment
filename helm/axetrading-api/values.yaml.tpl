replicaCount: ${replicaSetCount}

image:
  repository: ${imageRepository}
  pullPolicy: ${imagePullPolicy}
  tag: ${imageTag}

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

resources: {}
  # limits:
  #   cpu: 100m
  #   memory: 128Mi
  # requests:
  #   cpu: 100m
  #   memory: 128Mi
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
  enabled: ${autoscalingEnabled}
  %{~ if autoscalingEnabled ~}
  minReplicas: ${minReplicas}
  maxReplicas: ${maxReplicas}
  targetCPUUtilizationPercentage: ${targetCPUUtilization}
  targetMemoryUtilizationPercentage: ${targetMemoryUtilization}
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

nodeSelector: {}

tolerations: []

affinity: {}
