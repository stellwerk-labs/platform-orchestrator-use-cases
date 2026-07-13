terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    platform-orchestrator = {
      source  = "stellwerk-labs/platform-orchestrator"
      version = "~> 1.0"
    }
  }
}
