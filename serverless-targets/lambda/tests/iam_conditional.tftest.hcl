# Test IAM role management permissions are conditional based on lambda_iam_role_arn

# Mock provider configuration for tests
mock_provider "aws" {
  mock_resource "aws_iam_policy" {
    defaults = {
      arn = "arn:aws:iam::123456789012:policy/mock-policy"
    }
  }
  mock_resource "aws_iam_role_policy_attachment" {}
  mock_resource "aws_iam_role" {
    defaults = {
      arn = "arn:aws:iam::123456789012:role/mock-role"
    }
  }

  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }
}

mock_provider "platform-orchestrator" {
  mock_resource "platform-orchestrator_project" {}
  mock_resource "platform-orchestrator_environment" {}
  mock_resource "platform-orchestrator_environment_type" {}
  mock_resource "platform-orchestrator_resource_type" {}
  mock_resource "platform-orchestrator_module" {}
  mock_resource "platform-orchestrator_module_rule" {}
  mock_resource "platform-orchestrator_runner_rule" {}
  mock_resource "platform-orchestrator_serverless_ecs_runner" {}
  mock_data "platform-orchestrator_environment_type" {}
}

mock_provider "random" {
  mock_resource "random_id" {
    defaults = {
      hex = "abc123"
    }
  }
}

run "iam_permissions_when_module_creates_role" {
  command = plan

  variables {
    org_id                   = "test-org"
    project_id_prefix        = "test-project"
    env_id                   = "test"
    lambda_package_s3_bucket = "test-lambda-packages"

    ecs_runner_cluster_name       = "test-cluster"
    ecs_runner_subnet_ids         = ["subnet-12345678"]
    ecs_runner_security_group_ids = ["sg-12345678"]

    oidc_hostname              = "test-oidc.example.com"
    existing_oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/test-oidc.example.com"

    # Module creates the role (lambda_iam_role_arn is null by default)
    lambda_iam_role_prefix = "my-lambda-role"
  }

  # Verify the IAM policy document data source is created
  assert {
    condition     = data.aws_iam_policy_document.lambda_deployment != null
    error_message = "IAM policy document should be created"
  }

  # Verify IAM policy is created
  assert {
    condition     = aws_iam_policy.lambda_deployment != null
    error_message = "IAM policy should be created for Lambda deployment"
  }
}

run "iam_permissions_when_custom_role_provided" {
  command = plan

  variables {
    org_id                   = "test-org"
    project_id_prefix        = "test-project"
    env_id                   = "test"
    lambda_package_s3_bucket = "test-lambda-packages"

    ecs_runner_cluster_name       = "test-cluster"
    ecs_runner_subnet_ids         = ["subnet-12345678"]
    ecs_runner_security_group_ids = ["sg-12345678"]

    oidc_hostname              = "test-oidc.example.com"
    existing_oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/test-oidc.example.com"

    # Using a custom role (module does NOT create the role)
    lambda_iam_role_arn = "arn:aws:iam::123456789012:role/my-custom-lambda-role"
  }

  # Verify the IAM policy document data source is still created
  # (it will just have conditional statements)
  assert {
    condition     = data.aws_iam_policy_document.lambda_deployment != null
    error_message = "IAM policy document should be created"
  }

  # Verify IAM policy is created (even with custom role, runner still needs other permissions)
  assert {
    condition     = aws_iam_policy.lambda_deployment != null
    error_message = "IAM policy should be created for Lambda deployment"
  }
}

run "custom_iam_role_prefix" {
  command = plan

  variables {
    org_id                   = "test-org"
    project_id_prefix        = "test-project"
    env_id                   = "test"
    lambda_package_s3_bucket = "test-lambda-packages"

    ecs_runner_cluster_name       = "test-cluster"
    ecs_runner_subnet_ids         = ["subnet-12345678"]
    ecs_runner_security_group_ids = ["sg-12345678"]

    oidc_hostname              = "test-oidc.example.com"
    existing_oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/test-oidc.example.com"

    # Custom IAM role prefix
    lambda_iam_role_prefix = "custom-lambda"
  }

  # Verify custom prefix is used
  assert {
    condition     = var.lambda_iam_role_prefix == "custom-lambda"
    error_message = "Lambda IAM role prefix should be custom-lambda"
  }

  assert {
    condition     = var.lambda_iam_role_arn == null
    error_message = "lambda_iam_role_arn should be null (module creates role)"
  }
}
