#!/bin/bash

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

echo "Spot instance ready"
api_request "POST" "builds/$BUILD_ID/build_events" '{"type":"spot_instance_ready"}'

echo "Installing Docker"
sudo apt-get update
sudo apt-get -y install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Cloning repo"
TOKEN=$(api_request "POST" "github_tokens")
USER_DIR=/home/ubuntu
PROJECT_DIR=$USER_DIR/project
git clone https://x-access-token:$TOKEN@github.com/$GITHUB_REPO_FULL_NAME $PROJECT_DIR
cd $PROJECT_DIR
api_request "POST" "builds/$BUILD_ID/build_events" '{"type":"repository_cloned"}'

git clone https://x-access-token:$TOKEN@github.com/jasonswett/saturnci $USER_DIR/saturnci
cp $USER_DIR/saturnci/lib/custom_formatter.rb $PROJECT_DIR

sudo docker-compose -f .saturnci/docker-compose.yml run app rails db:create
api_request "POST" "builds/$BUILD_ID/build_events" '{"type":"test_suite_started"}'

echo "Running tests"
RESULTS_FILENAME=$USER_DIR/build_report.json
sudo docker-compose -f .saturnci/docker-compose.yml run \
  app bundle exec rspec \
  --require ./custom_formatter.rb \
  --format CustomFormatter > $RESULTS_FILENAME

echo "Test suite finished"
api_request "POST" "builds/$BUILD_ID/build_events" '{"type":"test_suite_finished"}'

echo "Sending report"
RESULTS_CONTENT=$(cat $RESULTS_FILENAME)
api_request "POST" "builds/$BUILD_ID/build_reports" "$RESULTS_CONTENT"

sudo poweroff
