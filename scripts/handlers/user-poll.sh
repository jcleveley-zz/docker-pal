#!/bin/bash

PAYLOAD=$(cat)

function extract_payload_arg() {
  echo $(echo $1 | awk -v num=$2 '{print $num}')
}

MEMBER_HOSTNAME=$(extract_payload_arg "$PAYLOAD", 1)
MEMBER_GIT_REPO_URL=$(extract_payload_arg "$PAYLOAD", 2)
MEMBER_GIT_REF=$(extract_payload_arg "$PAYLOAD", 3)
MEMBER_MASHERY_KEY=$(extract_payload_arg "$PAYLOAD" 4)

if [ "$MEMBER_HOSTNAME" != "$HOSTNAME" ]; then
  exit 0
fi

mkdir -p /mnt/hgfs

if [ ! -d "/mnt/hgfs/workspace/.git" ]; then
  git clone --depth=1 $MEMBER_GIT_REPO_URL /mnt/hgfs/workspace
  cd /mnt/hgfs/workspace
  git branch $MEMBER_GIT_REF
else
  cd /mnt/hgfs/workspace
  git pull origin $MEMBER_GIT_REF
fi

cd /mnt/hgfs/workspace/tabloid/webapp/static
gem20 install bundler
bundle install

npm install -g grunt-cli
npm install

grunt sass:service:news > /mnt/hgfs/workspace/tabloid/webapp/static/sass/log.txt

cat << EOF > /mnt/hgfs/workspace/configurator/src/main/BBC/News/Config/environments.local.ini
[sandbox]
candy.host =  https://d.bbc.co.uk
candyext.host = https://d.bbc.co.uk
candy.params.api_key = $MASHERY_KEY
EOF

serf event -coalesce=false service "$HOSTNAME httpd restart"
