#!/bin/bash

PAYLOAD=$(cat)

function extract_payload_arg() {
  echo $(echo $1 | awk -v num=$2 '{print $num}')
}

MEMBER_HOSTNAME=$(extract_payload_arg "$PAYLOAD" 1)
MEMBER_SERVICE=$(extract_payload_arg "$PAYLOAD" 2)
MEMBER_ACTION=$(extract_payload_arg "$PAYLOAD" 3)

if [ "$MEMBER_HOSTNAME" == "$HOSTNAME" ]; then
  /sbin/service $MEMBER_SERVICE $MEMBER_ACTION
fi

exit 0
