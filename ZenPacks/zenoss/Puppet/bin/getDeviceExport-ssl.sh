#!/bin/bash

#
# cURL example to show getting exports of devices
#

USERNAME="admin"
PASS="zenoss"

SERVER="127.0.0.1"
PORT="443"

data='{"deviceClass":"/","options":{}}'

curl --insecure -u "$USERNAME:$PASS" -X POST -H "Content-Type: application/json" -d '{"action":"PuppetRouter","method":"exportDevices","data":['${data}'], "tid":1}' "https://$SERVER:$PORT/zport/dmd/puppet_router"

echo

