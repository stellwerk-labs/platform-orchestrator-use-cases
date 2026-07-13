output "project_id" {
  description = "The ID of the Platform Orchestrator project"
  value       = platform-orchestrator_project.this.id
}

output "environment_id" {
  description = "The ID of the Platform Orchestrator environment"
  value       = platform-orchestrator_environment.this.id
}

output "ecs_runner_id" {
  description = "The ID of the ECS runner"
  value       = module.ecs_runner.runner_id
}

output "ecs_runner_task_role_name" {
  description = "The name of the ECS runner task role"
  value       = split("/", module.ecs_runner.task_role_arn)[1]
}

output "ecs_runner_task_role_arn" {
  description = "The ARN of the ECS runner task role"
  value       = module.ecs_runner.task_role_arn
}

output "lambda_deployment_policy_arn" {
  description = "The ARN of the IAM policy for Lambda deployment"
  value       = aws_iam_policy.lambda_deployment.arn
}

output "lambda_deployment_policy_name" {
  description = "The name of the IAM policy for Lambda deployment"
  value       = aws_iam_policy.lambda_deployment.name
}

output "lambda_zip_resource_type_id" {
  description = "The ID of the lambda-zip resource type"
  value       = platform-orchestrator_resource_type.lambda_zip.id
}

output "lambda_zip_module_id" {
  description = "The ID of the lambda-zip module"
  value       = platform-orchestrator_module.lambda_zip.id
}
