#!/bin/bash

SERVER_IP=$1
OPERATION=$2
PAYLOAD=$3

case $OPERATION in 
    POST)
    curl --header "Content-Type: application/json" \
      --request POST \
      --data @$PAYLOAD \
      http://$SERVER_IP:6080 
    ;;

    PUT)
    curl --header "Content-Type: application/json" \
      --request PUT \
      --data @$PAYLOAD \
      http://$SERVER_IP:6080
    ;;

    GET)
    curl http://$SERVER_IP:6080 
    ;;

    *)
    echo "Usage: 
    ./curl_replayd SERVER_IP <POST|PUT|GET> PAYLOAD
    PAYLOAD is not applicable for GET
    "
esac
