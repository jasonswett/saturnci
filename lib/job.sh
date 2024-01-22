#!/bin/bash

function api_request() {
    local method=$1
    local path=$2
    local data=$3

    curl -f -u $SATURNCI_API_USERNAME:$SATURNCI_API_PASSWORD \
        -X $method \
        -H "Content-Type: application/json" \
        -d "$data" \
        $HOST/api/v1/$path
}

function send_content_to_api() {
    local api_path=$1
    local content_type=$2
    local file_path=$3

    curl -f -u $SATURNCI_API_USERNAME:$SATURNCI_API_PASSWORD \
        -X POST \
        -H "Content-Type: $content_type" \
        --data-binary "@$file_path" "$HOST/api/v1/$api_path"
}

#--------------------------------------------------------------------------------

echo "Job machine ready"
api_request "POST" "jobs/$JOB_ID/job_events" '{"type":"job_machine_ready"}'

#--------------------------------------------------------------------------------

echo "Sending system logs"
send_content_to_api "jobs/$JOB_ID/system_logs" "text/plain" "/var/log/syslog"

#--------------------------------------------------------------------------------

echo "Deleting job machine"
api_request "DELETE" "jobs/$JOB_ID/job_machine"
