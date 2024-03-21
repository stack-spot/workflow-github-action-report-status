#!/bin/bash -l

execution_id=$1;
client_id=$2;
client_secret=$3;
realm=$4;
name=$5;
status=$6;
conclusion=$7;
log=$8;
idm_url=$9;
workflow_url=$10;
started_at=$(date +"%Y-%m-%d %T%z");
completed_at=$(date +"%Y-%m-%d %T%z");

workflow_service="$workflow_url/executions/$execution_id/workflows/steps"
idm_service="$idm_url/realms/$realm/protocol/openid-connect/token"

echo $workflow_service
echo $idm_service

secret_stk_login=$(curl --location --request POST "$idm_service" \
    --header "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "client_id=$client_id" \
    --data-urlencode "grant_type=client_credentials" \
    --data-urlencode "client_secret=$client_secret" | jq -r .access_token)

if [[ "$status" == "pending" ]]; then
    http_code=$(curl -s -o response.txt -w '%{http_code}' \
    --location --request PUT "$workflow_service" \
    --header "Authorization: Bearer $secret_stk_login" \
    --header 'Content-Type: application/json' \
    --data "{\"name\": \"$name\", \"status\": \"$status\", \"log\": \"$log\"}";)
elif [[ "$status" == "completed" ]]; then
    http_code=$(curl -s -o response.txt -w '%{http_code}' \
    --location --request PUT "$workflow_service" \
    --header "Authorization: Bearer $secret_stk_login" \
    --header 'Content-Type: application/json' \
    --data "{\"name\": \"$name\", \"status\": \"$status\", \"started_at\": \"$started_at\", \"completed_at\": \"$completed_at\", \"conclusion\": \"$conclusion\", \"log\": \"$log\"}";)
else
    http_code=$(curl -s -o response.txt -w '%{http_code}' \
    --location --request PUT "$workflow_service" \
    --header "Authorization: Bearer $secret_stk_login" \
    --header 'Content-Type: application/json' \
    --data "{\"name\": \"$name\", \"status\": \"$status\", \"started_at\": \"$started_at\", \"log\": \"$log\"}";)
fi

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