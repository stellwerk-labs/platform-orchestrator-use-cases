variable "org_id" {
  description = "The Platform Orchestrator organization ID"
  type        = string
}

variable "project_id_prefix" {
  description = "The Platform Orchestrator project ID prefix"
  type        = string
  default     = "lambda-project-"
}

variable "env_type_id_prefix" {
  description = "The environment type ID prefix (e.g., 'development', 'production')"
  type        = string
  default     = "development"
}

variable "env_id" {
  description = "The environment ID within the project"
  type        = string
  default     = "development"
}

variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "eu-central-1"
}

variable "ecs_runner_prefix" {
  description = "Prefix for the ECS runner resources (used when ecs_runner_cluster_name is null)"
  type        = string
  default     = "ecs-runner"
}

variable "ecs_runner_cluster_name" {
  description = "Name of the existing ECS cluster for the runner"
  type        = string
  default     = null
}

variable "ecs_runner_subnet_ids" {
  description = "List of subnet IDs for the ECS runner"
  type        = list(string)
  default     = []
}

variable "ecs_runner_security_group_ids" {
  description = "List of security group IDs for the ECS runner"
  type        = list(string)
  default     = []
}

variable "ecs_runner_id" {
  description = "The ID of the ECS runner. If not provided, one will be generated using ecs_runner_prefix"
  type        = string
  default     = null
}

variable "ecs_runner_environment" {
  description = "Plain text environment variables to expose in the ECS runner"
  type        = map(string)
  default     = {}
}

variable "ecs_runner_secrets" {
  description = "Secret environment variables to expose in the ECS runner. Each value should be a secret or property ARN"
  type        = map(string)
  default     = {}
}

variable "ecs_runner_force_delete_s3" {
  description = "Force delete the ECS runner S3 state files bucket on destroy even if it's not empty"
  type        = bool
  default     = true
}

variable "oidc_hostname" {
  description = "Hostname of the OIDC issuer exposed by your Platform Orchestrator installation"
  type        = string
}

variable "existing_oidc_provider_arn" {
  description = "ARN of the existing OIDC provider"
  type        = string
  default     = null
}

variable "lambda_timeout" {
  description = "Default timeout for Lambda functions in seconds"
  type        = number
  default     = 100
}

variable "lambda_package_s3_bucket" {
  description = "S3 bucket name for Lambda deployment packages"
  type        = string
}

variable "lambda_module_id_prefix" {
  description = "Prefix for the Lambda module and resource type IDs"
  type        = string
  default     = "lambda-zip-"
}

variable "lambda_name_prefix" {
  description = "Prefix for Lambda function names. Supports Platform Orchestrator context variables like $${context.project_id}"
  type        = string
  default     = "$${context.project_id}"
}

variable "lambda_additional_inline_policies" {
  description = "Map of additional inline IAM policies to attach to the Lambda execution role. Each key is the policy name and value is the JSON-encoded policy document."
  type        = map(string)
  default     = {}
}

variable "lambda_runtime" {
  description = "Lambda runtime environment"
  type        = string
  default     = "nodejs22.x"
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default     = "index.handler"
}

variable "lambda_memory_size" {
  description = "Amount of memory in MB that your Lambda function can use at runtime. Valid value between 128 MB to 10,240 MB"
  type        = number
  default     = 128
}

variable "lambda_architectures" {
  description = "Instruction set architecture for the Lambda function. Valid values: ['x86_64'] or ['arm64']"
  type        = list(string)
  default     = ["x86_64"]
}

variable "lambda_iam_role_arn" {
  description = "Optional IAM role ARN to use for the Lambda function. If not provided, a new role will be created"
  type        = string
  default     = null
}

variable "lambda_iam_role_prefix" {
  description = "Prefix for Lambda execution IAM role names when roles are created by the module (only used when lambda_iam_role_arn is null)"
  type        = string
  default     = "lambda-role-"
}

variable "lambda_additional_managed_policy_arns" {
  description = "List of additional managed IAM policy ARNs to attach to the Lambda execution role"
  type        = list(string)
  default     = []
}

variable "lambda_additional_tags" {
  description = "Additional tags to apply to the Lambda function"
  type        = map(string)
  default     = {}
}

variable "lambda_enable_function_url" {
  description = "Enable Lambda function URL"
  type        = bool
  default     = false
}

variable "lambda_function_url_auth_type" {
  description = "Authorization type for the Function URL. 'NONE' = public access, 'AWS_IAM' = requires AWS credentials"
  type        = string
  default     = "AWS_IAM"

  validation {
    condition     = contains(["NONE", "AWS_IAM"], var.lambda_function_url_auth_type)
    error_message = "lambda_function_url_auth_type must be either 'NONE' or 'AWS_IAM'."
  }
}

variable "lambda_function_url_cors" {
  description = "CORS configuration for the Function URL. Only applies if lambda_enable_function_url is true"
  type = object({
    allow_credentials = optional(bool, false)
    allow_origins     = optional(list(string), ["*"])
    allow_methods     = optional(list(string), ["*"])
    allow_headers     = optional(list(string), [])
    expose_headers    = optional(list(string), [])
    max_age           = optional(number, 0)
  })
  default = null
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
