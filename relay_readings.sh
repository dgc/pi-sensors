#!/bin/bash

HOST=labbroker.soton.ac.uk
TOPIC=rPI_46_1047_2
LOG=${HOME}/${TOPIC}.log

# wait for networking
sleep 10

while true
do
  /usr/bin/python -u /home/pi/sensors/process_readings.py | \
  /usr/bin/tee -a $LOG | \
  /usr/bin/mosquitto_pub -l -q 2 -h $HOST -t $TOPIC
  /bin/sleep 1
done
