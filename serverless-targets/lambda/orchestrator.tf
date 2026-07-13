## Project

resource "platform-orchestrator_project" "this" {
  id = local.project_id
}


## ECS Runner

module "ecs_runner" {
  source = "github.com/stellwerk-tf-modules/serverless-ecs-orchestrator-runner?ref=v2.0.0"

  region                     = var.aws_region
  runner_id                  = var.ecs_runner_id
  runner_id_prefix           = var.ecs_runner_prefix
  existing_ecs_cluster_name  = var.ecs_runner_cluster_name
  subnet_ids                 = var.ecs_runner_subnet_ids
  security_group_ids         = var.ecs_runner_security_group_ids
  orchestrator_org_id        = var.org_id
  oidc_hostname              = var.oidc_hostname
  existing_oidc_provider_arn = var.existing_oidc_provider_arn
  environment                = var.ecs_runner_environment
  secrets                    = var.ecs_runner_secrets
  force_delete_s3            = var.ecs_runner_force_delete_s3
  additional_tags = merge(
    {
      project = local.project_id
    },
    var.additional_tags
  )
}


# Create a runner rule
resource "platform-orchestrator_runner_rule" "this" {
  runner_id  = module.ecs_runner.runner_id
  project_id = platform-orchestrator_project.this.id
}

resource "platform-orchestrator_environment_type" "this" {
  id = local.env_type_id
}


# Create an environment
resource "platform-orchestrator_environment" "this" {
  id          = var.env_id
  project_id  = platform-orchestrator_project.this.id
  env_type_id = platform-orchestrator_environment_type.this.id

  # Ensure the runner rule is in place so that the Orchestrator may assign a runner to the environment
  depends_on = [platform-orchestrator_runner_rule.this]
}

# Create a resource type "lambda-zip" with an output schema
resource "platform-orchestrator_resource_type" "lambda_zip" {
  id          = "lambda-zip"
  description = "Lambda function zip package stored in S3"
  output_schema = jsonencode({
    type = "object"
    properties = {
      function_name = {
        type        = "string"
        description = "The name of the Lambda function"
      }
      function_arn = {
        type        = "string"
        description = "The ARN of the Lambda function"
      }
      function_url = {
        type        = "string"
        description = "The HTTPS URL endpoint for the Lambda function (if enable_function_url is true)"
      }
      invoke_arn = {
        type        = "string"
        description = "The ARN to be used for invoking the Lambda function from API Gateway"
      }
      role_arn = {
        type        = "string"
        description = "The ARN of the IAM role assumed by the Lambda function"
      }
    }
  })
  is_developer_accessible = true
}

# Create a module, setting values for the module variables
resource "platform-orchestrator_module" "lambda_zip" {
  id            = local.lambda_module_id
  description   = "Lambda function zip package"
  resource_type = platform-orchestrator_resource_type.lambda_zip.id
  module_source = "git::https://github.com/stellwerk-tf-modules/serverless-lambda?ref=v1.0.0"

  module_params = {
    s3_key = {
      type        = "string"
      description = "The S3 key for the Lambda deployment package"
    }
    environment_variables = {
      type        = "map"
      is_optional = true
      description = "Function environment variables"
    }
  }
  module_inputs = jsonencode({
    s3_bucket                      = var.lambda_package_s3_bucket
    handler                        = var.lambda_handler
    runtime                        = var.lambda_runtime
    iam_role_arn                   = var.lambda_iam_role_arn
    architectures                  = var.lambda_architectures
    timeout_in_seconds             = var.lambda_timeout
    additional_tags                = var.lambda_additional_tags
    memory_size                    = var.lambda_memory_size
    name_prefix                    = var.lambda_name_prefix
    additional_managed_policy_arns = var.lambda_additional_managed_policy_arns
    additional_inline_policies     = var.lambda_additional_inline_policies
    enable_function_url            = var.lambda_enable_function_url
    function_url_auth_type         = var.lambda_function_url_auth_type
    function_url_cors              = var.lambda_function_url_cors
  })
}

# Create a module rule making the module applicable to the project
resource "platform-orchestrator_module_rule" "lambda_zip" {
  module_id  = platform-orchestrator_module.lambda_zip.id
  project_id = platform-orchestrator_project.this.id
}
