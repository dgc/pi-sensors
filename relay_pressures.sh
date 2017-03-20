#!/bin/bash

TOPIC=$1

DEV=/dev/ttyUSB1
HOST=labbroker.soton.ac.uk
LOG=pressures.log

# wait for networking
sleep 10

/bin/stty -F $DEV 9600

for (( ; ; ))
do
  /usr/bin/logger -t SensorRelay Starting CurrentCost relay
  /usr/bin/ruby /home/pi/sensors/relay_pressures.rb $DEV | \
    /usr/bin/tee -a $LOG | \
    /usr/bin/mosquitto_pub -l -q 2 -h $HOST -t $TOPIC
  /bin/sleep 1
done
