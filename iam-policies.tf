data "aws_iam_policy_document" "secrets" {
  count = var.create_role && var.attach_secrets_policy ? 1 : 0

  statement {
    actions = [
      "secretsmanager:ListSecrets",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "ssm:DescribeParameters",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "kms:Decrypt",
      "kms:GetKeyRotationStatus",
      "kms:GetKeyPolicy",
      "kms:DescribeKey",
    ]
    resources = ["*"]
  }

}

resource "aws_iam_policy" "secrets" {
  count = var.create_role && var.attach_secrets_policy ? 1 : 0

  name_prefix = "${var.policy_name_prefix}Secrets_Policy-"
  path        = var.role_path
  description = "Provides permissions for IRSA attached to a kubernetes SA to get secrets from AWS SSM and AWS Secrets Manager"
  policy      = data.aws_iam_policy_document.secrets[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "secrets" {
  count = var.create_role && var.attach_secrets_policy ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.secrets[0].arn
}