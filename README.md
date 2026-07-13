# Platform Orchestrator Use Cases

This repository contains use cases demonstrating the capabilities of the [Stellwerk Platform Orchestrator](https://docs.stellwerk.dev/platform-orchestrator/).

## Purpose

This repository serves as a collection of practical use cases showcasing how to leverage Platform Orchestrator for various scenarios and implementation patterns.

## Authoring

Create a directory or sub-directory to contain your use case. A use case consists of a README and a Terraform/OpenTofu module for executing it.

The README must contain all the instructions for the use case execution. This usually includes some Terraform/OpenTofu code utilizing the use case module as a `module`.

The use case directory must contain:

- (required) A `README.md`
- (required) A `main.tf` file
- (optional) Any number of further `.tf` files to make up the use case module
- (optional, but recommended) A `tests` directory containing TF test files

The `README.md` file must have:

- A level 1 `# Heading`. This heading is used as the title of the use case page generated in the developer docs
- A sentence following that heading with a concise description of the use case. This sentence is used as the `description` of the use case page generated in the developer docs
- Level 2 `## Headings` for further sections. These headings will make up the TOC of the use case page generated in the developer docs

## Resources

- [Platform Orchestrator Documentation](https://docs.stellwerk.dev/platform-orchestrator/)
- [Platform Orchestrator Terraform Provider](https://registry.terraform.io/providers/stellwerk-labs/platform-orchestrator/latest)

## Getting Started

More information about specific use cases will be added as they are developed.
