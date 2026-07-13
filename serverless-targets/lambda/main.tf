# Generate random ids to avoid naming conflicts

resource "random_id" "project_id" {
  byte_length = 4
  prefix      = var.project_id_prefix
}

resource "random_id" "env_type_id" {
  byte_length = 4
  prefix      = var.env_type_id_prefix
}

resource "random_id" "lambda_module_id" {
  byte_length = 4
  prefix      = var.lambda_module_id_prefix
}

locals {
  project_id       = random_id.project_id.hex
  env_type_id      = random_id.env_type_id.hex
  lambda_module_id = random_id.lambda_module_id.hex
}

