#!/bin/bash

USER_DIR=/home/ubuntu
TEST_OUTPUT_FILENAME=tmp/build_log.txt
TEST_RESULTS_FILENAME=tmp/test_results.txt

# Function to perform API request
function api_request() {
    local method=$1
    local path=$2
    local data=$3

    curl -u $SATURNCI_API_USERNAME:$SATURNCI_API_PASSWORD \
        -X $method \
        -H "Content-Type: application/json" \
        -d "$data" \
        $HOST/api/v1/$path
}

#--------------------------------------------------------------------------------

echo "Build machine ready"
api_request "POST" "builds/$BUILD_ID/build_events" '{"type":"build_machine_ready"}'

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
PROJECT_DIR=$USER_DIR/project
git clone https://x-access-token:$TOKEN@github.com/$GITHUB_REPO_FULL_NAME $PROJECT_DIR
cd $PROJECT_DIR
api_request "POST" "builds/$BUILD_ID/build_events" '{"type":"repository_cloned"}'

#--------------------------------------------------------------------------------

echo "Cloning Saturn"
git clone https://x-access-token:$TOKEN@github.com/jasonswett/saturnci $USER_DIR/saturnci
cp $USER_DIR/saturnci/lib/example_status_persistence.rb $PROJECT_DIR

sudo docker-compose -f .saturnci/docker-compose.yml run app rails db:create
api_request "POST" "builds/$BUILD_ID/build_events" '{"type":"test_suite_started"}'

#--------------------------------------------------------------------------------

echo "Running tests"
script -c "sudo docker-compose -f .saturnci/docker-compose.yml run -e TEST_RESULTS_FILENAME=$TEST_RESULTS_FILENAME app bundle exec rspec --require ./example_status_persistence.rb --format=documentation" -f "$TEST_OUTPUT_FILENAME"

#--------------------------------------------------------------------------------

echo "Test suite finished"
api_request "POST" "builds/$BUILD_ID/build_events" '{"type":"test_suite_finished"}'

#--------------------------------------------------------------------------------

echo "Sending report"
curl -u $SATURNCI_API_USERNAME:$SATURNCI_API_PASSWORD \
  -X POST \
  -H "Content-Type: text/plain" \
  --data-binary "@$TEST_RESULTS_FILENAME" "${HOST}/api/v1/builds/$BUILD_ID/build_reports"

#--------------------------------------------------------------------------------

echo "Sending test output"
curl -u $SATURNCI_API_USERNAME:$SATURNCI_API_PASSWORD \
  -X POST \
  -H "Content-Type: text/plain" \
  --data-binary "@$TEST_OUTPUT_FILENAME" "${HOST}/api/v1/builds/$BUILD_ID/build_logs"

#--------------------------------------------------------------------------------

echo "Sending general logs"
curl -u $SATURNCI_API_USERNAME:$SATURNCI_API_PASSWORD \
  -X POST \
  -H "Content-Type: text/plain" \
  --data-binary "@/var/log/syslog" "${HOST}/api/v1/builds/$BUILD_ID/build_logs"

#api_request "DELETE" "builds/$BUILD_ID/build_machine"
