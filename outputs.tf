
output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = try(aws_iam_role.this[0].arn, "")
}

output "helm_release_id" {
  value = helm_release.main.id
}

output "helm_release_name" {
  value = helm_release.main.name
}

output "helm_release_namespace" {
  value = helm_release.main.namespace
}