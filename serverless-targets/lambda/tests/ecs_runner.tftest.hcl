# Tests for ECS runner configuration variables

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

run "ecs_runner_with_custom_id" {
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

    # Custom runner ID
    ecs_runner_id = "custom-runner-id"
  }

  # Validate custom runner ID is set
  assert {
    condition     = var.ecs_runner_id == "custom-runner-id"
    error_message = "Custom ECS runner ID should be set"
  }
}

run "ecs_runner_with_environment_variables" {
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

    # Environment variables
    ecs_runner_environment = {
      LOG_LEVEL = "debug"
      DEBUG     = "true"
      REGION    = "eu-central-1"
    }
  }

  # Validate environment variables are set
  assert {
    condition     = length(var.ecs_runner_environment) == 3
    error_message = "Should have 3 environment variables"
  }

  assert {
    condition     = var.ecs_runner_environment["LOG_LEVEL"] == "debug"
    error_message = "LOG_LEVEL should be debug"
  }

  assert {
    condition     = var.ecs_runner_environment["DEBUG"] == "true"
    error_message = "DEBUG should be true"
  }
}

run "ecs_runner_with_secrets" {
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

    # Secrets
    ecs_runner_secrets = {
      API_KEY     = "arn:aws:secretsmanager:eu-central-1:123456789012:secret:api-key-AbCdEf"
      DB_PASSWORD = "arn:aws:ssm:eu-central-1:123456789012:parameter/db/password"
    }
  }

  # Validate secrets are set
  assert {
    condition     = length(var.ecs_runner_secrets) == 2
    error_message = "Should have 2 secrets"
  }

  assert {
    condition     = can(regex("^arn:aws:secretsmanager:", var.ecs_runner_secrets["API_KEY"]))
    error_message = "API_KEY should be a Secrets Manager ARN"
  }

  assert {
    condition     = can(regex("^arn:aws:ssm:", var.ecs_runner_secrets["DB_PASSWORD"]))
    error_message = "DB_PASSWORD should be a Parameter Store ARN"
  }
}

run "ecs_runner_force_delete_s3_enabled" {
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

    # Enable force delete
    ecs_runner_force_delete_s3 = true
  }

  # Validate force_delete_s3 is enabled
  assert {
    condition     = var.ecs_runner_force_delete_s3 == true
    error_message = "force_delete_s3 should be enabled"
  }
}

run "ecs_runner_default_values" {
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
  }

  # Validate default values
  assert {
    condition     = var.ecs_runner_id == null
    error_message = "Default ecs_runner_id should be null"
  }

  assert {
    condition     = length(var.ecs_runner_environment) == 0
    error_message = "Default ecs_runner_environment should be empty"
  }

  assert {
    condition     = length(var.ecs_runner_secrets) == 0
    error_message = "Default ecs_runner_secrets should be empty"
  }

  assert {
    condition     = var.ecs_runner_force_delete_s3 == true
    error_message = "Default ecs_runner_force_delete_s3 should be true"
  }
}

run "ecs_runner_with_all_custom_options" {
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

    # All custom options
    ecs_runner_id              = "my-runner"
    ecs_runner_force_delete_s3 = true
    ecs_runner_environment = {
      APP_ENV = "production"
    }
    ecs_runner_secrets = {
      SECRET_KEY = "arn:aws:secretsmanager:eu-central-1:123456789012:secret:key-AbCdEf"
    }
  }

  # Validate all custom options are set
  assert {
    condition     = var.ecs_runner_id == "my-runner"
    error_message = "Custom runner ID should be set"
  }

  assert {
    condition     = var.ecs_runner_force_delete_s3 == true
    error_message = "force_delete_s3 should be true"
  }

  assert {
    condition     = length(var.ecs_runner_environment) == 1
    error_message = "Should have 1 environment variable"
  }

  assert {
    condition     = length(var.ecs_runner_secrets) == 1
    error_message = "Should have 1 secret"
  }
}
