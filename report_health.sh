#!/bin/bash

DEVICE=$1

MQTT_HOST=labbroker.soton.ac.uk
MQTT_CHAN=device_status
TIMESTAMP=`/bin/date -u +\%s`
IPV4_ADDR=`/sbin/ifconfig eth0 | /bin/grep -o '^\ *inet addr:[0-9.]*' | /bin/grep -o '[0-9.]*'`
MAC_ADDR=`/sbin/ifconfig eth0 | /bin/grep -oP 'HWaddr [0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}' | /bin/sed -e 's/HWaddr //'`
SPACE=`/bin/df / | /usr/bin/awk '{if (NR!=1) {print}}' | /bin/grep -oP '[0-9]+%' | /bin/grep -oP '[0-9]+'`
LOAD=`/usr/bin/uptime | /bin/grep -oP 'load average: [0-9.]+,' | /bin/grep -oP '[0-9.]+'`

/usr/bin/mosquitto_pub -h $MQTT_HOST -t $MQTT_CHAN -m "{\"timestamp\":$TIMESTAMP,\"device\":\"$DEVICE\",\"ipv4_address\":\"$IPV4_ADDR\",\"mac_address\":\"$MAC_ADDR\",\"space\":$SPACE,\"load\":$LOAD}"
