#!/bin/bash
# This script iterates through all directories of the repository to execute Terraform/OpenTofu actions.
# It does so in any directory having a "main.tf" file.
# The tool (terraform or tofu) must be set via the TF_TOOL environment variable
# Actions are
# - ${TF_TOOL} init
# - ${TF_TOOL} fmt (only iif DO_TF_FORMAT == "true")
# - ${TF_TOOL} validate
# - ${TF_TOOL} test
# - terraform-docs (only if DO_TF_DOCS == "true")

set -e

# Find all directories containing main.tf
echo "Searching for directories with main.tf files..."

while IFS= read -r -d '' main_tf_file; do
  dir=$(dirname "$main_tf_file")
  echo ""
  echo "=========================================="
  echo "Processing directory: $dir"
  echo "=========================================="

  cd "$GITHUB_WORKSPACE/$dir"

  echo "Initializing ${TF_TOOL} in $dir..."
  ${TF_TOOL} init -backend=false

  if [ "$DO_TF_FORMAT" == "true" ]; then
    echo "Formatting ..."
    ${TF_TOOL} fmt --check --recursive
  fi

  echo "Validating ..."
  ${TF_TOOL} validate
  echo "Running tests ..."
  ${TF_TOOL} test

  if [ "$DO_TF_DOCS" == "true" ]; then
    echo "Running terraform-docs ..."
    $GITHUB_WORKSPACE/terraform-docs markdown table --output-file README.md --output-mode inject .
  fi

  # Return to workspace root
  cd "$GITHUB_WORKSPACE"

done < <(find . -name "main.tf" -type f -print0)