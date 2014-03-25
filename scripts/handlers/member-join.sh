#!/bin/bash

PAYLOAD=$(cat)

MEMBER_IPADDR=$(echo $PAYLOAD | awk '{print $2}')
LOCAL_IPADDR=$(hostname --ip-address)

if [ "$MEMBER_IPADDR" == "$LOCAL_IPADDR" ]; then
  extaccess "pal.$DOMAIN" "static.$DOMAIN:$PORT" "ichef.$DOMAIN:$PORT"

  serf event -coalesce=false poll "$HOSTNAME $GIT_REPO_URL $GIT_REF $MASHERY_KEY"
  serf event -coalesce=false service "$HOSTNAME httpd start"
  serf event -coalesce=false service "$HOSTNAME memcached start"
fi
