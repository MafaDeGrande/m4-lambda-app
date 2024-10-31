resource "aws_grafana_workspace" "lambda_monitor" {
  name = var.name
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  data_sources = ["CLOUDWATCH"]
  role_arn = aws_iam_role.assume.arn
}

resource "aws_grafana_role_association" "role" {
  role = "ADMIN"
  group_ids = [var.group_id] 
  workspace_id = aws_grafana_workspace.lambda_monitor.id
}

resource "aws_iam_role" "assume" {
  name = "grafana-assume"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      },
    ]
  })
}
