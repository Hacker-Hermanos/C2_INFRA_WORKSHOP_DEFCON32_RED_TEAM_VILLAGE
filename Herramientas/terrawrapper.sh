#!/bin/sh
# autor: Robert Pimentel - www.linkedin.com/in/pimentelrobert1 / Hacker Hermanos - www.linkedin.com/company/hackerhermanos 
# Sitio web: https://hackerhermanos.com
# Descripción: Este script proporciona una forma automatizada de desplegar o destruir infraestructura gestionada por Terraform, 
# con opciones para especificar el espacio de trabajo de Terraform y el nombre del archivo de plan.
# Licencia: The unlicense

# Configura el script para que se detenga si hay algún error
set -e

# Definición de variables globales importantes
# Obtiene el nombre del script actual
SCRIPT_NAME=$(basename "$0")
# Define el nombre predeterminado del archivo de plan
PLAN_FILE="Exercise_1.tfplan"
# Construye la ruta completa al archivo de plan
PLAN_PATH="$(pwd)/$PLAN_FILE"
# Define el nombre del archivo de variables de Terraform
TERRAFORM_VARS_FILE="terraform.tfvars"

# Función que muestra cómo usar el script y sus opciones disponibles
usage() {
    echo "Uso: $SCRIPT_NAME [--deploy|--destroy] [--workspace <nombre-workspace>] [--plan-file <nombre-archivo-plan>]"
    echo
    echo "Argumentos:"
    echo "  --deploy                   Desplegar la infraestructura de Terraform."
    echo "  --destroy                  Destruir la infraestructura de Terraform."
    echo "  --workspace <nombre-workspace>    Especificar el espacio de trabajo de Terraform a usar o crear."
    echo "  --plan-file <nombre-archivo-plan>    Especificar el nombre del archivo de plan."
    echo
    echo "Ejemplos:"
    echo "  Desplegar infraestructura en el espacio de trabajo predeterminado:"
    echo "    $SCRIPT_NAME --deploy"
    echo
    echo "  Destruir infraestructura en el espacio de trabajo predeterminado:"
    echo "    $SCRIPT_NAME --destroy"
    echo
    echo "  Desplegar infraestructura en un espacio de trabajo específico:"
    echo "    $SCRIPT_NAME --deploy --workspace dev"
    echo
    echo "  Destruir infraestructura en un espacio de trabajo específico:"
    echo "    $SCRIPT_NAME --destroy --workspace dev"
    echo
    echo "  Desplegar infraestructura con un archivo de plan específico:"
    echo "    $SCRIPT_NAME --deploy --plan-file my_plan.tfplan"
    exit 1
}

# Función para registrar mensajes con un tipo (INFO, WARNING, etc.)
log() {
    local type="$1"
    local msg="$2"
    echo "[$type] $msg"
}

# Función para inicializar Terraform y descargar los providers necesarios
initialize_terraform() {
    log "INFO" "Inicializando Terraform..."
    terraform init --upgrade
}

# Función para seleccionar o crear un workspace de Terraform
# Los workspaces permiten manejar múltiples estados de infraestructura
select_workspace() {
    local workspace=$1
    if [ -n "$workspace" ]; then
        log "INFO" "Seleccionando workspace de Terraform: $workspace"
        terraform workspace select "$workspace" || terraform workspace new "$workspace"
    fi
}

# Función para formatear los archivos de Terraform según el estándar
format_terraform_files() {
    log "INFO" "Formateando archivos de Terraform..."
    terraform fmt
}

# Función para validar la sintaxis y configuración de los archivos de Terraform
validate_terraform_files() {
    log "INFO" "Validando archivos de Terraform..."
    terraform validate
}

# Función para crear un plan de Terraform (ya sea para crear o destruir infraestructura)
plan_terraform() {
    local destroy=$1
    # Verifica si existe el archivo de variables
    if [ -f "$TERRAFORM_VARS_FILE" ]; then
        VAR_FILE_OPTION="-var-file=$TERRAFORM_VARS_FILE"
    else
        VAR_FILE_OPTION=""
        log "WARNING" "El archivo de variables $TERRAFORM_VARS_FILE no existe. Continuando sin él."
    fi

    # Crea el plan según si es para destruir o crear infraestructura
    if [ "$destroy" = "true" ]; then
        log "INFO" "Planificando destrucción de Terraform..."
        terraform plan -destroy -out "$PLAN_PATH" $VAR_FILE_OPTION
    else
        log "INFO" "Planificando cambios de Terraform..."
        terraform plan -out "$PLAN_PATH" $VAR_FILE_OPTION
    fi
    log "INFO" "Plan guardado en $PLAN_PATH"
}

# Función para aplicar los cambios planificados
apply_terraform() {
    log "INFO" "Aplicando cambios de Terraform..."
    terraform apply --auto-approve "$PLAN_PATH"
    log "INFO" "¡Aplicación completada exitosamente!"
}

# Función para destruir la infraestructura existente
destroy_terraform() {
    log "INFO" "Destruyendo infraestructura gestionada por Terraform..."
    terraform destroy --auto-approve
    log "INFO" "¡Destrucción completada exitosamente!"
}

# Verifica que se haya proporcionado al menos un argumento
if [ $# -lt 1 ]; then
    usage
fi

# Inicialización de variables para los argumentos
ACTION=""
WORKSPACE=""
PLAN_FILE_ARG=""

# Procesa los argumentos de línea de comandos
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

# Actualiza el nombre del archivo de plan si se especificó uno diferente
if [ -n "$PLAN_FILE_ARG" ]; then
    PLAN_FILE="$PLAN_FILE_ARG"
    PLAN_PATH="$(pwd)/$PLAN_FILE"
fi

# Ejecuta la secuencia de acciones según el comando especificado
case $ACTION in
    deploy)
        log "INFO" "Iniciando proceso de despliegue..."
        initialize_terraform
        select_workspace "$WORKSPACE"
        format_terraform_files
        validate_terraform_files
        plan_terraform "false"
        apply_terraform
        ;;
    destroy)
        log "INFO" "Iniciando proceso de destrucción..."
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

log "INFO" "Operación completada."
