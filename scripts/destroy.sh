#!/usr/bin/env bash
set -euo pipefail
: "${CONFIRM_DESTROY:?Set CONFIRM_DESTROY=I_UNDERSTAND to continue}"
[[ "$CONFIRM_DESTROY" == I_UNDERSTAND ]] || { echo 'Refusing teardown: confirmation mismatch' >&2; exit 1; }
vars="${1:-terraform/terraform.tfvars}"
terraform -chdir=terraform plan -destroy -var-file="$vars"
read -r -p 'Type DESTROY to apply this teardown: ' answer
[[ "$answer" == DESTROY ]] || exit 1
terraform -chdir=terraform destroy -var-file="$vars"
