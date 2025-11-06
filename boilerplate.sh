#!/usr/bin/env bash
#
# ============================================
#  Script Name:   devops-template-assoc.sh
#  Description:   DevOps automation boilerplate using associative-array arguments
#  Author:        Nithin Saai Shiva
#  Created:       2025-11-05
# ============================================

# --- Strict & Safe Bash settings ---
set -Eeuo pipefail
IFS=$'\n\t'

# --- Globals ---
SCRIPT_NAME="$(basename "$0")"
DEBUG=false

# --- Logging helpers ---
red='\033[1;31m'; green='\033[1;32m'; yellow='\033[1;33m'; reset='\033[0m'

timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

log() {
    local level="$1"; shift
    printf "[%s] [%s] [%s] %s\n" "$(timestamp)" "$SCRIPT_NAME" "$level" "$*"
}

info()  { log "${green}[INFO]${reset}" "$@"; }
warn()  { log "${yellow}[WARN]${reset}" "$@" >&2; }
error() { log "${red}[ERROR]${reset}" "$@" >&2; }
debug() { $DEBUG && log "DEBUG" "$@"; }

# --- Traps for clean exit ---
trap 'error "Unexpected error on line $LINENO"; exit 1' ERR
trap 'warn "Script interrupted"; exit 130' INT TERM

# --- Utility: require a command ---
require_command() {
    local cmd="$1"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        error "Missing required command: $cmd"
        exit 1
    fi
}

# --- Utility: confirm action ---
confirm() {
    local msg="$1"
    read -rp "$msg [y/N]: " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

business_logic() {
}

usage() {
    cat <<EOF
Usage: $SCRIPT_NAME [options] <subcommand>

Options:
  -v, --verbose       Enable debug logging
  -h, --help          Show this help message

Subcommands:
  run              Run a deployment

Examples:
  $SCRIPT_NAME run args...
EOF
}

main() {
    local subcommand=""

    # Parse global options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -v|--verbose) DEBUG=true; shift ;;
            -h|--help) usage; exit 0 ;;
            run)
                subcommand="$1"; shift; break ;;
            *)
                error "Unknown option: $1"
                usage; exit 1 ;;
        esac
    done

    # Convert key=value args into associative array
    declare -A args=()
    for arg in "$@"; do
        [[ "$arg" == *=* ]] || { error "Invalid argument format: $arg (use key=value)"; exit 1; }
        key="${arg%%=*}"
        value="${arg#*=}"
        args["$key"]="$value"
    done

    # Dispatch subcommands
    case "$subcommand" in
        run)
            business_logic args
            ;;
        "")
            usage
            ;;
        *)
            error "Unknown subcommand: $subcommand"
            usage
            exit 1
            ;;
    esac
}

main "$@"
