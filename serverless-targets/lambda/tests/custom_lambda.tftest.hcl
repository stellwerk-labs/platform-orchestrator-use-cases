# Test custom Lambda function configuration

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

run "custom_lambda_runtime" {
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

    # Custom Lambda configuration
    lambda_runtime     = "python3.12"
    lambda_handler     = "main.handler"
    lambda_timeout     = 300
    lambda_memory_size = 512
  }

  assert {
    condition     = var.lambda_runtime == "python3.12"
    error_message = "Lambda runtime should be python3.12"
  }

  assert {
    condition     = var.lambda_handler == "main.handler"
    error_message = "Lambda handler should be main.handler"
  }

  assert {
    condition     = var.lambda_timeout == 300
    error_message = "Lambda timeout should be 300 seconds"
  }

  assert {
    condition     = var.lambda_memory_size == 512
    error_message = "Lambda memory size should be 512 MB"
  }
}

run "custom_lambda_architectures" {
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

    # ARM architecture
    lambda_architectures = ["arm64"]
  }

  assert {
    condition     = length(var.lambda_architectures) == 1 && var.lambda_architectures[0] == "arm64"
    error_message = "Lambda architecture should be arm64"
  }
}

run "custom_lambda_iam_policies" {
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

    # Custom IAM policies
    lambda_additional_managed_policy_arns = [
      "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
      "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
    ]

    lambda_additional_inline_policies = {
      custom_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"secretsmanager:GetSecretValue\"],\"Resource\":\"arn:aws:secretsmanager:*:*:secret:my-secret-*\"}]}"
    }
  }

  assert {
    condition     = length(var.lambda_additional_managed_policy_arns) == 2
    error_message = "Should have 2 managed policy ARNs"
  }

  assert {
    condition     = length(var.lambda_additional_inline_policies) == 1
    error_message = "Should have 1 inline policy"
  }
}

run "custom_lambda_tags" {
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

    # Custom tags
    lambda_additional_tags = {
      Application = "MyApp"
      Environment = "Production"
      Team        = "Platform"
    }

    additional_tags = {
      ManagedBy = "Terraform"
      Project   = "Lambda-Target"
    }
  }

  assert {
    condition     = length(var.lambda_additional_tags) == 3
    error_message = "Should have 3 Lambda tags"
  }

  assert {
    condition     = length(var.additional_tags) == 2
    error_message = "Should have 2 additional tags"
  }
}
