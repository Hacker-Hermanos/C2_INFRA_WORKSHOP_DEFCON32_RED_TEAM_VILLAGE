#!/bin/sh
# Author: Robert Pimentel - www.linkedin.com/in/pimentelrobert1 / Hacker Hermanos - www.linkedin.com/company/hackerhermanos 
# Website: https://hackerhermanos.com
# Description: This script provides an automated way to deploy or destroy infrastructure managed by Terraform,
# with options to specify the Terraform workspace and the plan file name.
# License: The unlicense

# Configure the script to stop if there is any error
set -e

# Definition of important global variables
# Get the current script name
SCRIPT_NAME=$(basename "$0")
# Define the default plan file name
PLAN_FILE="Exercise_1.tfplan"
# Build the full path to the plan file
PLAN_PATH="$(pwd)/$PLAN_FILE"
# Define the Terraform variables file name
TERRAFORM_VARS_FILE="terraform.tfvars"

# Function that shows how to use the script and its available options
usage() {
    echo "Usage: $SCRIPT_NAME [--deploy|--destroy] [--workspace <workspace-name>] [--plan-file <plan-file-name>]"
    echo
    echo "Arguments:"
    echo "  --deploy                   Deploy the Terraform infrastructure."
    echo "  --destroy                  Destroy the Terraform infrastructure."
    echo "  --workspace <workspace-name>    Specify the Terraform workspace to use or create."
    echo "  --plan-file <plan-file-name>    Specify the plan file name."
    echo
    echo "Examples:"
    echo "  Deploy infrastructure in the default workspace:"
    echo "    $SCRIPT_NAME --deploy"
    echo
    echo "  Destroy infrastructure in the default workspace:"
    echo "    $SCRIPT_NAME --destroy"
    echo
    echo "  Deploy infrastructure in a specific workspace:"
    echo "    $SCRIPT_NAME --deploy --workspace dev"
    echo
    echo "  Destroy infrastructure in a specific workspace:"
    echo "    $SCRIPT_NAME --destroy --workspace dev"
    echo
    echo "  Deploy infrastructure with a specific plan file:"
    echo "    $SCRIPT_NAME --deploy --plan-file my_plan.tfplan"
    exit 1
}

# Function to log messages with a type (INFO, WARNING, etc.)
log() {
    local type="$1"
    local msg="$2"
    echo "[$type] $msg"
}

# Function to initialize Terraform and download the necessary providers
initialize_terraform() {
    log "INFO" "Initializing Terraform..."
    terraform init --upgrade
}

# Function to select or create a Terraform workspace
# Workspaces allow managing multiple infrastructure states
select_workspace() {
    local workspace=$1
    if [ -n "$workspace" ]; then
        log "INFO" "Selecting Terraform workspace: $workspace"
        terraform workspace select "$workspace" || terraform workspace new "$workspace"
    fi
}

# Function to format Terraform files according to the standard
format_terraform_files() {
    log "INFO" "Formatting Terraform files..."
    terraform fmt
}

# Function to validate the syntax and configuration of Terraform files
validate_terraform_files() {
    log "INFO" "Validating Terraform files..."
    terraform validate
}

# Function to create a Terraform plan (either to create or destroy infrastructure)
plan_terraform() {
    local destroy=$1
    # Check if the variables file exists
    if [ -f "$TERRAFORM_VARS_FILE" ]; then
        VAR_FILE_OPTION="-var-file=$TERRAFORM_VARS_FILE"
    else
        VAR_FILE_OPTION=""
        log "WARNING" "The variables file $TERRAFORM_VARS_FILE does not exist. Continuing without it."
    fi

    # Create the plan depending on whether it is to destroy or create infrastructure
    if [ "$destroy" = "true" ]; then
        log "INFO" "Planning Terraform destruction..."
        terraform plan -destroy -out "$PLAN_PATH" $VAR_FILE_OPTION
    else
        log "INFO" "Planning Terraform changes..."
        terraform plan -out "$PLAN_PATH" $VAR_FILE_OPTION
    fi
    log "INFO" "Plan saved in $PLAN_PATH"
}

# Function to apply the planned changes
apply_terraform() {
    log "INFO" "Applying Terraform changes..."
    terraform apply --auto-approve "$PLAN_PATH"
    log "INFO" "Resources have been successfully deployed!"
}

# Function to destroy the existing infrastructure
destroy_terraform() {
    log "INFO" "Destroying infrastructure managed by Terraform..."
    terraform destroy --auto-approve
    log "INFO" "Destruction completed successfully!"
}

# Check that at least one argument has been provided
if [ $# -lt 1 ]; then
    usage
fi

# Initialization of variables for the arguments
ACTION=""
WORKSPACE=""
PLAN_FILE_ARG=""

# Process command line arguments
while [ "$1" != "" ]; do
    case $1 in
        --deploy)
            ACTION="deploy"
            ;;
        --destroy)
            ACTION="destroy"
            ;;
        --workspace)
            shift
            WORKSPACE=$1
            ;;
        --plan-file)
            shift
            PLAN_FILE_ARG=$1
            ;;
        *)
            usage
            ;;
    esac
    shift
done

# Update the plan file name if a different one was specified
if [ -n "$PLAN_FILE_ARG" ]; then
    PLAN_FILE="$PLAN_FILE_ARG"
    PLAN_PATH="$(pwd)/$PLAN_FILE"
fi

# Execute the sequence of actions according to the specified command
case $ACTION in
    deploy)
        log "INFO" "Starting deployment process..."
        initialize_terraform
        select_workspace "$WORKSPACE"
        format_terraform_files
        validate_terraform_files
        plan_terraform "false"
        apply_terraform
        ;;
    destroy)
        log "INFO" "Starting destruction process..."
        initialize_terraform
        select_workspace "$WORKSPACE"
        format_terraform_files
        validate_terraform_files
        plan_terraform "true"
        destroy_terraform
        ;;
    *)
        usage
        ;;
esac

log "INFO" "Operation completed."
