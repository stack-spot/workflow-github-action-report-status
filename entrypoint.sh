#!/bin/bash -l

execution_id=$1
client_id=$2
client_secret=$3
realm=$4
status=$6
started_at=$(date +"%Y-%m-%d %T%z");
completed_at=$(date +"%Y-%m-%d %T%z");
step_conclusion='success';

secret_stk_login=$(curl --location --request POST "https://idm.stackspot.com/realms/$realm/protocol/openid-connect/token" \
    --header "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "client_id=$client_id" \
    --data-urlencode "grant_type=client_credentials" \
    --data-urlencode "client_secret=$client_secret" | jq -r .access_token)

http_code=$(curl -s -o response.txt -w '%{http_code}' \
  --location --request PUT "https://workflow-api.v1.stackspot.com/executions/$execution_id/workflows/steps/" \
  --header "Authorization: Bearer $secret_stk_login" \
  --header 'Content-Type: application/json' \
  --data "{\"name\": \"$status\", \"started_at\": \"$started_at\", \"completed_at\": \"$completed_at\", \"conclusion\": \"$step_conclusion\"}";)

if [[ "$http_code" -ne "200" ]]; then
    echo "------------------------------------------------------------------------------------------"
    echo "---------------------------------------- Error Reporting ---------------------------------"
    echo "------------------------------------------------------------------------------------------"
    echo "HTTP_CODE:" $http_code
    echo "RESPONSE_CONTENT:"
    cat response.txt
    exit $http_code
else
    echo "------------------------------------------------------------------------------------------"
    echo "---------------------------------------- Success Reporting -------------------------------"
    echo "------------------------------------------------------------------------------------------"
    echo "HTTP_CODE:" $http_code
    cat response.txt
fi