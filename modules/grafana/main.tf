resource "aws_grafana_workspace" "lambda_monitor" {
  name = var.name
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  grafana_version = "9.4"
  data_sources = ["CLOUDWATCH"]
  role_arn = aws_iam_role.assume.arn
}

resource "aws_grafana_role_association" "role" {
  role = "ADMIN"
  group_ids = [var.group_id] 
  workspace_id = aws_grafana_workspace.lambda_monitor.id
}

resource "aws_iam_role" "assume" {
  name = var.name
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

resource "aws_iam_role_policy" "grafana_cloudwatch_access" {
  name = var.name
  role = aws_iam_role.assume.name

    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:DescribeAlarms"
        ]
        Resource = "*"
      }
    ]
  })
}
