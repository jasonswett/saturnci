curl -X POST -d "type=spot_instance_ready" $HOST/api/v1/builds/$BUILD_ID/build_events

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

TOKEN=$(curl -X POST $HOST/api/v1/github_tokens)
PROJECT_DIR=/home/ubuntu/project
git clone https://x-access-token:$TOKEN@github.com/jasonswett/mars $PROJECT_DIR
cd $PROJECT_DIR
curl -X POST -d "type=repository_cloned" $HOST/api/v1/builds/$BUILD_ID/build_events

git clone https://x-access-token:$TOKEN@github.com/jasonswett/saturnci ../saturnci
cp ../saturnci/lib/custom_formatter.rb .

sudo docker-compose -f .saturnci/docker-compose.yml run app rails db:create
curl -X POST -d "type=test_suite_started" $HOST/api/v1/builds/$BUILD_ID/build_events

sudo docker-compose -f .saturnci/docker-compose.yml run \
  app bundle exec rspec \
  --require ./custom_formatter.rb \
  --format CustomFormatter

curl -X POST -d "type=test_suite_finished" $HOST/api/v1/builds/$BUILD_ID/build_events
