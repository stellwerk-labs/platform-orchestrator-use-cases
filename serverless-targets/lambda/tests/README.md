# Lambda Serverless Target Module Tests

This directory contains automated tests for the Lambda serverless target Terraform module.

## Test Structure

The tests are organized into the following files:

- **`basic.tftest.hcl`** - Basic validation tests
  - Tests module with minimal required configuration
  - Validates default values
  - Ensures all required resources are created

- **`custom_lambda.tftest.hcl`** - Custom Lambda configuration tests
  - Tests custom runtime and handler configurations
  - Tests ARM architecture support
  - Tests custom IAM policies (managed and inline)
  - Tests custom tags

- **`function_url.tftest.hcl`** - Lambda Function URL tests
  - Tests Function URL enablement
  - Tests public vs IAM-authenticated access
  - Tests CORS configuration
  - Tests invalid auth type validation

- **`iam_conditional.tftest.hcl`** - IAM conditional permissions tests
  - Tests IAM permissions when module creates roles (lambda_iam_role_arn is null)
  - Tests IAM permissions when custom role is provided
  - Tests custom IAM role prefix configuration

## Prerequisites

- Terraform >= 1.8.0
- AWS credentials configured (for plan validation)
- Platform Orchestrator provider credentials (if running against real API)

## Running Tests

### Run All Tests

```bash
terraform init
terraform test
```

### Run Specific Test File

```bash
terraform init
terraform test -filter=tests/basic.tftest.hcl
terraform test -filter=tests/custom_lambda.tftest.hcl
terraform test -filter=tests/function_url.tftest.hcl
```

### Run from Module Root

If you're in the module root directory:

```bash
cd orchestrator-use-cases/serverless-targets/lambda
terraform test
```

### Verbose Output

```bash
terraform test -verbose
```

## Test Coverage

The test suite covers:

- ✅ Module validation with minimal configuration
- ✅ Default values verification
- ✅ Custom Lambda runtime configurations
- ✅ Lambda architecture options (x86_64, arm64)
- ✅ IAM policy configurations (managed and inline)
- ✅ Conditional IAM role management permissions
- ✅ Custom IAM role prefix
- ✅ Resource tagging
- ✅ Function URL configurations
- ✅ CORS settings
- ✅ Input validation

## Writing New Tests

To add new tests:

1. Create a new `.tftest.hcl` file in this directory
2. Define test runs with descriptive names
3. Set required variables
4. Add assertions to validate expected behavior

### Test File Template

```hcl
# Test description

run "test_name" {
  command = plan

  variables {
    org_id             = "test-org"
    project_id_prefix  = "test-project"
    env_id             = "test"
    s3_bucket          = "test-bucket"

    # ... other required variables
  }

  assert {
    condition     = <condition to test>
    error_message = "Description of what failed"
  }
}
```

## Continuous Integration

These tests can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions
- name: Run Terraform Tests
  run: |
    cd orchestrator-use-cases/serverless-targets/lambda
    terraform init
    terraform test
```

## Troubleshooting

### Test Failures

If tests fail:

1. Check that all required variables are set correctly
2. Verify Terraform and provider versions meet requirements
3. Run with `-verbose` flag for detailed output
4. Check assertion conditions are correct

### Provider Authentication

For tests that require provider authentication, ensure:

- AWS credentials are configured
- Platform Orchestrator API token is set (if needed)
- Provider configuration is correct

## Additional Resources

- [Terraform Testing Documentation](https://developer.hashicorp.com/terraform/language/tests)
- [Module README](../README.md)
- [Platform Orchestrator Documentation](https://docs.stellwerk.dev/platform-orchestrator/)
