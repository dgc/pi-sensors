#!/bin/bash

TOPIC=$1

DEV=/dev/ttyUSB0
HOST=labbroker.soton.ac.uk
LOG=current_cost.log

# wait for networking
sleep 10

/bin/stty -F $DEV 57600

for (( ; ; ))
do
  /usr/bin/logger -t SensorRelay Starting CurrentCost relay
  /usr/bin/ruby /home/pi/sensors/timestamp_and_jsonify.rb $DEV | \
    /usr/bin/tee -a $LOG | \
    /usr/bin/mosquitto_pub -l -q 2 -h $HOST -t $TOPIC
  /bin/sleep 1
done
