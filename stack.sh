#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<EOF
Usage: $0 <cloud/service> <plan|apply|destroy> [-y|--yes] [-- <extra terraform args>]

  cloud/service        Subdirectory containing the Terraform root config, e.g. aws/eks
  plan                 Format, init, and show the plan (no changes applied)
  apply                Format, init, plan, then apply after confirmation
  destroy              Format, init, plan a destroy, then apply after confirmation
  -y, --yes            Skip the confirmation prompt for apply/destroy
  -h, --help           Show this help message

Each service directory has its own terraform.tfvars (gitignored, local-only) with required
values already set, so no -var flags are needed by default. Any other arguments passed here
(e.g. -var cluster_name=override) are passed through to terraform plan to override it.

Examples:
  $0 aws/eks plan
  $0 aws/eks apply
  $0 aws/eks destroy -y
  $0 github plan
EOF
  exit 1
}

[[ $# -ge 2 ]] || usage

SERVICE="$1"
ACTION="$2"
shift 2

case "$ACTION" in
  plan|apply|destroy) ;;
  -h|--help) usage ;;
  *)
    echo "Error: unknown action '$ACTION' (expected plan, apply, or destroy)" >&2
    usage
    ;;
esac

SERVICE_DIR="$SCRIPT_DIR/$SERVICE"
if [[ ! -d "$SERVICE_DIR" ]]; then
  echo "Error: no such service directory: $SERVICE_DIR" >&2
  exit 1
fi

AUTO_APPROVE=false
EXTRA_ARGS=()
for arg in "$@"; do
  case "$arg" in
    -y|--yes) AUTO_APPROVE=true ;;
    *) EXTRA_ARGS+=("$arg") ;;
  esac
done

if [[ "$SERVICE" == github* ]]; then
	source ${CROC}/github.sh; load-github-app
  MISSING_APP_VARS=()
  for var in GITHUB_APP_ID GITHUB_APP_INSTALLATION_ID GITHUB_APP_PEM_FILE; do
    [[ -n "${!var:-}" ]] || MISSING_APP_VARS+=("$var")
  done
  if [[ ${#MISSING_APP_VARS[@]} -gt 0 ]]; then
    echo "Error: missing required env var(s) for the $SERVICE stack: ${MISSING_APP_VARS[*]}" >&2
    cat <<EOF >&2

Export these before running '$0 $SERVICE ...':
  export GITHUB_APP_ID=...
  export GITHUB_APP_INSTALLATION_ID=...
  export GITHUB_APP_PEM_FILE="\$(cat /path/to/key.pem)"
EOF
    exit 1
  fi
fi

cd "$SERVICE_DIR"

PLAN_FILE="$(mktemp -t "${SERVICE//\//-}-tfplan")"
trap 'rm -f "$PLAN_FILE"' EXIT

echo "==> [$SERVICE] Formatting Terraform files"
terraform fmt -recursive .

echo "==> [$SERVICE] Initializing Terraform (reconfigure backend)"
terraform init -input=false -reconfigure

echo "==> [$SERVICE] Selecting Terraform workspace 'ps'"
terraform workspace select -or-create=true ps

case "$ACTION" in
  plan)
    echo "==> [$SERVICE] Planning"
    terraform plan -input=false "${EXTRA_ARGS[@]+"${EXTRA_ARGS[@]}"}"
    exit 0
    ;;
  apply)
    echo "==> [$SERVICE] Planning"
    terraform plan -input=false -out="$PLAN_FILE" "${EXTRA_ARGS[@]+"${EXTRA_ARGS[@]}"}"
    ;;
  destroy)
    echo "==> [$SERVICE] Planning destroy"
    terraform plan -input=false -destroy -out="$PLAN_FILE" "${EXTRA_ARGS[@]+"${EXTRA_ARGS[@]}"}"
    ;;
esac

if [[ "$AUTO_APPROVE" != true ]]; then
  echo
  read -r -p "Apply the plan above? [y/N] " CONFIRM
  if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Aborted. No changes applied."
    exit 0
  fi
fi

echo "==> [$SERVICE] Applying plan"
terraform apply -input=false "$PLAN_FILE"
