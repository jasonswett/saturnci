#!/bin/bash

USER_DIR=/home/ubuntu
PROJECT_DIR=$USER_DIR/project
TEST_OUTPUT_FILENAME=tmp/test_output.txt
TEST_RESULTS_FILENAME=tmp/test_results.txt

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

echo "Installing Docker"
sudo apt-get update
sudo apt-get -y install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

#--------------------------------------------------------------------------------

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#--------------------------------------------------------------------------------

echo "Cloning user repo"
TOKEN=$(api_request "POST" "github_tokens" "{\"github_installation_id\":\"$GITHUB_INSTALLATION_ID\"}")
git clone https://x-access-token:$TOKEN@github.com/$GITHUB_REPO_FULL_NAME $PROJECT_DIR
cd $PROJECT_DIR
mkdir tmp
api_request "POST" "jobs/$JOB_ID/job_events" '{"type":"repository_cloned"}'

#--------------------------------------------------------------------------------

echo "Checking out commit $COMMIT_HASH"
git checkout $COMMIT_HASH

#--------------------------------------------------------------------------------

echo "Running docker-compose build"
api_request "POST" "jobs/$JOB_ID/job_events" '{"type":"image_build_started"}'
sudo docker-compose -f .saturnci/docker-compose.yml build
api_request "POST" "jobs/$JOB_ID/job_events" '{"type":"image_build_finished"}'

#--------------------------------------------------------------------------------

echo "Running pre.sh"
api_request "POST" "jobs/$JOB_ID/job_events" '{"type":"pre_script_started"}'
sudo chmod 755 .saturnci/pre.sh
sudo docker-compose -f .saturnci/docker-compose.yml run saturn_test_app ./.saturnci/pre.sh
api_request "POST" "jobs/$JOB_ID/job_events" '{"type":"pre_script_finished"}'

#--------------------------------------------------------------------------------

echo "Running tests"
api_request "POST" "jobs/$JOB_ID/job_events" '{"type":"test_suite_started"}'

cat <<EOF > ./example_status_persistence.rb
RSpec.configure do |config|
  config.example_status_persistence_file_path = '$TEST_RESULTS_FILENAME'
end
EOF

script -c "sudo docker-compose -f .saturnci/docker-compose.yml run saturn_test_app \
  bundle exec rspec --require ./example_status_persistence.rb \
  --format=documentation --order rand:$RSPEC_SEED \
  --example \"/$(expr ${JOB_ORDER_INDEX} % 2)/\"" \
  -f "$TEST_OUTPUT_FILENAME"

#--------------------------------------------------------------------------------

echo "Test suite finished"
api_request "POST" "jobs/$JOB_ID/job_events" '{"type":"test_suite_finished"}'

#--------------------------------------------------------------------------------

echo "Sending system logs"
send_content_to_api "jobs/$JOB_ID/system_logs" "text/plain" "/var/log/syslog"

#--------------------------------------------------------------------------------

echo "Sending test output"
send_content_to_api "jobs/$JOB_ID/test_output" "text/plain" "$TEST_OUTPUT_FILENAME"

#--------------------------------------------------------------------------------

echo "Sending report"
send_content_to_api "jobs/$JOB_ID/test_reports" "text/plain" "$TEST_RESULTS_FILENAME"

#--------------------------------------------------------------------------------

echo "Deleting job machine"
api_request "DELETE" "jobs/$JOB_ID/job_machine"
