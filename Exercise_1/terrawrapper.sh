#!/bin/sh
# author: Robert Pimentel - www.linkedin.com/in/pimentelrobert1 / Hacker Hermanos - www.linkedin.com/company/hackerhermanos 
# Website: https://hackerhermanos.com
# Description: The script provides an automated way to deploy or destroy Terraform-managed infrastructure, with options to specify the Terraform workspace and the name of the plan file. 
# License: The unlicense

set -e

SCRIPT_NAME=$(basename "$0")
PLAN_FILE="Exercise_1.tfplan"
PLAN_PATH="$(pwd)/$PLAN_FILE"
TERRAFORM_VARS_FILE="terraform.tfvars"

usage() {
    echo "Usage: $SCRIPT_NAME [--deploy|--destroy] [--workspace <workspace-name>] [--plan-file <plan-file-name>]"
    echo
    echo "Arguments:"
    echo "  --deploy                   Deploy the Terraform infrastructure."
    echo "  --destroy                  Destroy the Terraform infrastructure."
    echo "  --workspace <workspace>    Specify the Terraform workspace to use or create."
    echo "  --plan-file <plan-file>    Specify the name of the plan file."
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

log() {
    local type="$1"
    local msg="$2"
    echo "[$type] $msg"
}

initialize_terraform() {
    log "INFO" "Initializing Terraform..."
    terraform init --upgrade
}

select_workspace() {
    local workspace=$1
    if [ -n "$workspace" ]; then
        log "INFO" "Selecting Terraform workspace: $workspace"
        terraform workspace select "$workspace" || terraform workspace new "$workspace"
    fi
}

format_terraform_files() {
    log "INFO" "Formatting Terraform files..."
    terraform fmt
}

validate_terraform_files() {
    log "INFO" "Validating Terraform files..."
    terraform validate
}

plan_terraform() {
    local destroy=$1
    if [ -f "$TERRAFORM_VARS_FILE" ]; then
        VAR_FILE_OPTION="-var-file=$TERRAFORM_VARS_FILE"
    else
        VAR_FILE_OPTION=""
        log "WARNING" "Variables file $TERRAFORM_VARS_FILE does not exist. Proceeding without it."
    fi

    if [ "$destroy" = "true" ]; then
        log "INFO" "Planning Terraform destroy..."
        terraform plan -destroy -out "$PLAN_PATH" $VAR_FILE_OPTION
    else
        log "INFO" "Planning Terraform changes..."
        terraform plan -out "$PLAN_PATH" $VAR_FILE_OPTION
    fi
    log "INFO" "Plan saved to $PLAN_PATH"
}

apply_terraform() {
    log "INFO" "Applying Terraform changes..."
    terraform apply --auto-approve "$PLAN_PATH"
    log "INFO" "Apply completed successfully!"
}

destroy_terraform() {
    log "INFO" "Destroying Terraform-managed infrastructure..."
    terraform destroy --auto-approve
    log "INFO" "Destroy completed successfully!"
}

if [ $# -lt 1 ]; then
    usage
fi

ACTION=""
WORKSPACE=""
PLAN_FILE_ARG=""

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

if [ -n "$PLAN_FILE_ARG" ]; then
    PLAN_FILE="$PLAN_FILE_ARG"
    PLAN_PATH="$(pwd)/$PLAN_FILE"
fi

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
