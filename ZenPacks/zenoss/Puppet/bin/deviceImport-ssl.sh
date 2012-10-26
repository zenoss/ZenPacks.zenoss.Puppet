#!/bin/bash

#
# cURL example to show getting imports of devices
#

USERNAME="admin"
PASS="zenoss"

SERVER="127.0.0.1"
PORT="443"

data='{"data":"/Devices/Server/Linux/blue\nwubble","options":{}}'

curl --insecure -u "$USERNAME:$PASS" -X POST -H "Content-Type: application/json" -d '{"action":"PuppetRouter","method":"importDevices","data":['${data}'], "tid":1}' "https://$SERVER:$PORT/zport/dmd/puppet_router"

echo

