## IAM Policy for ECS Runner to Deploy Lambda Functions
data "aws_iam_policy_document" "lambda_deployment" {
  # Lambda Function management needed by ECS Runner
  statement {
    sid = "LambdaFunctionManagement"
    actions = [
      "lambda:CreateFunction",
      "lambda:DeleteFunction",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:ListVersionsByFunction",
      "lambda:PublishVersion",
      "lambda:GetPolicy",
      "lambda:AddPermission",
      "lambda:RemovePermission",
      "lambda:TagResource",
      "lambda:UntagResource",
      "lambda:ListTags",
      "lambda:GetFunctionCodeSigningConfig"
    ]
    resources = [
      "arn:aws:lambda:${var.aws_region}:*:function:*"
    ]
  }

  # Lambda Function URL management needed by ECS Runner
  statement {
    sid = "LambdaFunctionURLManagement"
    actions = [
      "lambda:CreateFunctionUrlConfig",
      "lambda:DeleteFunctionUrlConfig",
      "lambda:GetFunctionUrlConfig",
      "lambda:UpdateFunctionUrlConfig"
    ]
    resources = [
      "arn:aws:lambda:${var.aws_region}:*:function:*"
    ]
  }

  # IAM role and policy management for Lambda execution roles needed by ECS Runner
  statement {
    sid = "IAMRoleManagement"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:UpdateRole",
      "iam:PassRole",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:ListRoleTags",
      "iam:ListInstanceProfilesForRole"
    ]
    resources = var.lambda_iam_role_arn != null ? [var.lambda_iam_role_arn] : ["arn:aws:iam::*:role/${var.lambda_iam_role_prefix}*"]
  }

  statement {
    sid = "IAMPolicyManagement"
    actions = [
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies"
    ]
    resources = concat(
      var.lambda_iam_role_arn != null ? [var.lambda_iam_role_arn] : ["arn:aws:iam::*:role/${var.lambda_iam_role_prefix}*"],
      ["arn:aws:iam::*:policy/*"]
    )
  }


  # S3 access for Lambda deployment packages
  statement {
    sid = "S3DeploymentPackageAccess"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.lambda_package_s3_bucket}",
      "arn:aws:s3:::${var.lambda_package_s3_bucket}/*"
    ]
  }
}

# Create IAM policy from the policy document
resource "aws_iam_policy" "lambda_deployment" {
  name        = "${var.ecs_runner_prefix}-lambda-deployment"
  description = "Permissions for ECS Runner to deploy Lambda functions"
  policy      = data.aws_iam_policy_document.lambda_deployment.json

  tags = merge(
    {
      project = var.project_id_prefix
      purpose = "lambda-deployment"
    },
    var.additional_tags
  )
}

# Attach the policy to the ECS runner task role
resource "aws_iam_role_policy_attachment" "ecs_runner_lambda_deployment" {
  role       = split("/", module.ecs_runner.task_role_arn)[1]
  policy_arn = aws_iam_policy.lambda_deployment.arn
}
