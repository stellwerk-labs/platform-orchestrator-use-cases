# Basic validation test for the Lambda serverless target module

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

run "basic_configuration" {
  command = plan

  variables {
    org_id                   = "test-org"
    project_id_prefix        = "test-project"
    env_id                   = "test"
    lambda_package_s3_bucket = "test-lambda-packages"

    # ECS Runner configuration
    ecs_runner_cluster_name       = "test-cluster"
    ecs_runner_subnet_ids         = ["subnet-12345678"]
    ecs_runner_security_group_ids = ["sg-12345678"]

    # OIDC configuration
    oidc_hostname              = "test-oidc.example.com"
    existing_oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/test-oidc.example.com"
  }

  # Validate that required resources will be created
  assert {
    condition     = platform-orchestrator_project.this != null
    error_message = "Project resource should be created"
  }

  assert {
    condition     = platform-orchestrator_environment.this != null
    error_message = "Environment resource should be created"
  }

  assert {
    condition     = platform-orchestrator_resource_type.lambda_zip != null
    error_message = "Lambda resource type should be created"
  }

  assert {
    condition     = platform-orchestrator_module.lambda_zip != null
    error_message = "Lambda module should be created"
  }

  assert {
    condition     = platform-orchestrator_module_rule.lambda_zip != null
    error_message = "Module rule should be created"
  }
}

run "validate_default_values" {
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
    condition     = var.lambda_timeout == 100
    error_message = "Default Lambda timeout should be 100 seconds"
  }

  assert {
    condition     = var.lambda_runtime == "nodejs22.x"
    error_message = "Default Lambda runtime should be nodejs22.x"
  }

  assert {
    condition     = var.lambda_handler == "index.handler"
    error_message = "Default Lambda handler should be index.handler"
  }

  assert {
    condition     = var.lambda_memory_size == 128
    error_message = "Default Lambda memory size should be 128 MB"
  }

  assert {
    condition     = var.lambda_enable_function_url == false
    error_message = "Function URL should be disabled by default"
  }

  assert {
    condition     = var.lambda_function_url_auth_type == "AWS_IAM"
    error_message = "Default function URL auth type should be AWS_IAM"
  }
}
