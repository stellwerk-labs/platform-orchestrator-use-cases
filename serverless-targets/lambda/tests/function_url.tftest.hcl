# Test Lambda Function URL configurations

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

run "function_url_enabled" {
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

    # Function URL enabled with default auth
    lambda_enable_function_url = true
  }

  assert {
    condition     = var.lambda_enable_function_url == true
    error_message = "Function URL should be enabled"
  }

  assert {
    condition     = var.lambda_function_url_auth_type == "AWS_IAM"
    error_message = "Default auth type should be AWS_IAM"
  }
}

run "function_url_disabled" {
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

    # Function URL disabled
    lambda_enable_function_url = false
  }

  assert {
    condition     = var.lambda_enable_function_url == false
    error_message = "Function URL should be disabled"
  }
}

run "function_url_public_access" {
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

    # Public Function URL
    lambda_enable_function_url    = true
    lambda_function_url_auth_type = "NONE"
  }

  assert {
    condition     = var.lambda_function_url_auth_type == "NONE"
    error_message = "Auth type should be NONE for public access"
  }
}

run "function_url_with_cors" {
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

    # Function URL with CORS
    lambda_enable_function_url    = true
    lambda_function_url_auth_type = "NONE"
    lambda_function_url_cors = {
      allow_credentials = true
      allow_origins     = ["https://example.com", "https://app.example.com"]
      allow_methods     = ["GET", "POST", "PUT"]
      allow_headers     = ["Content-Type", "Authorization"]
      expose_headers    = ["X-Request-Id"]
      max_age           = 3600
    }
  }

  assert {
    condition     = var.lambda_function_url_cors != null
    error_message = "CORS configuration should be set"
  }

  assert {
    condition     = var.lambda_function_url_cors.allow_credentials == true
    error_message = "CORS should allow credentials"
  }

  assert {
    condition     = length(var.lambda_function_url_cors.allow_origins) == 2
    error_message = "Should have 2 allowed origins"
  }

  assert {
    condition     = var.lambda_function_url_cors.max_age == 3600
    error_message = "CORS max age should be 3600"
  }
}

run "invalid_auth_type" {
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

    # Invalid auth type - should fail validation
    lambda_function_url_auth_type = "INVALID"
  }

  expect_failures = [
    var.lambda_function_url_auth_type,
  ]
}
