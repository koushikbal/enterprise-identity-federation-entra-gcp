#!/usr/bin/env bash
set -euo pipefail
: "${AZURE_OIDC_TOKEN:?Set AZURE_OIDC_TOKEN to a short-lived Entra OIDC JWT}"
: "${GCP_WORKLOAD_PROVIDER:?Set GCP_WORKLOAD_PROVIDER to the full provider resource name}"
: "${GCP_SERVICE_ACCOUNT_EMAIL:?Set GCP_SERVICE_ACCOUNT_EMAIL}"
token="$(curl --fail-with-body -sS -X POST https://sts.googleapis.com/v1/token -H 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'grant_type=urn:ietf:params:oauth:grant-type:token-exchange' --data-urlencode 'audience=//iam.googleapis.com/'"$GCP_WORKLOAD_PROVIDER" --data-urlencode 'scope=https://www.googleapis.com/auth/cloud-platform' --data-urlencode 'requested_token_type=urn:ietf:params:oauth:token-type:access_token' --data-urlencode 'subject_token_type=urn:ietf:params:oauth:token-type:jwt' --data-urlencode "subject_token=$AZURE_OIDC_TOKEN" | python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')"
access="$(curl --fail-with-body -sS -X POST "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/$GCP_SERVICE_ACCOUNT_EMAIL:generateAccessToken" -H "Authorization: Bearer $token" -H 'Content-Type: application/json' -d '{"scope":["https://www.googleapis.com/auth/cloud-platform"],"lifetime":"900s"}' | python3 -c 'import json,sys; print(json.load(sys.stdin)["accessToken"])')"
export GOOGLE_OAUTH_ACCESS_TOKEN="$access"
printf '%s\n' "$access"
