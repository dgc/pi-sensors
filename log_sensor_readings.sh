#!/bin/bash

MQTT_SERVER="labbroker.soton.ac.uk"
MQTT_TOPIC="rPI_46_1047_1"

SENSOR_01="10-000802b42b40"
SENSOR_02="10-000802b44f21"
SENSOR_03="10-000802b49201"
SENSOR_04="10-000802b4b181"
SENSOR_05="28-00000720f6e6"
SENSOR_06="28-000007213db1"
# SENSOR_07="28-000007217131"
SENSOR_07="28-0000072191f9"
SENSOR_08="28-000007474609"
SENSOR_09="28-000007491929"

if lsmod | grep -q w1_gpio ; then

  TIMESTAMP=$(date +%s)

  TEMP_01=$(cat /sys/bus/w1/devices/$SENSOR_01/w1_slave | grep -o -P 't=\d+' | grep -o -P '\d+')
  TEMP_02=$(cat /sys/bus/w1/devices/$SENSOR_02/w1_slave | grep -o -P 't=\d+' | grep -o -P '\d+')
  TEMP_03=$(cat /sys/bus/w1/devices/$SENSOR_03/w1_slave | grep -o -P 't=\d+' | grep -o -P '\d+')
  TEMP_04=$(cat /sys/bus/w1/devices/$SENSOR_04/w1_slave | grep -o -P 't=\d+' | grep -o -P '\d+')
  TEMP_05=$(cat /sys/bus/w1/devices/$SENSOR_05/w1_slave | grep -o -P 't=\d+' | grep -o -P '\d+')
  TEMP_06=$(cat /sys/bus/w1/devices/$SENSOR_06/w1_slave | grep -o -P 't=\d+' | grep -o -P '\d+')
  TEMP_07=$(cat /sys/bus/w1/devices/$SENSOR_07/w1_slave | grep -o -P 't=\d+' | grep -o -P '\d+')
  TEMP_08=$(cat /sys/bus/w1/devices/$SENSOR_08/w1_slave | grep -o -P 't=\d+' | grep -o -P '\d+')
  TEMP_09=$(cat /sys/bus/w1/devices/$SENSOR_09/w1_slave | grep -o -P 't=\d+' | grep -o -P '\d+')
#  TEMP_10=$(cat /sys/bus/w1/devices/$SENSOR_10/w1_slave | grep -o -P 't=\d+' | grep -o -P '\d+')

  TS="\"timestamp\":${TIMESTAMP}"

  R01="\"${SENSOR_01}\":${TEMP_01}"
  R02="\"${SENSOR_02}\":${TEMP_02}"
  R03="\"${SENSOR_03}\":${TEMP_03}"
  R04="\"${SENSOR_04}\":${TEMP_04}"
  R05="\"${SENSOR_05}\":${TEMP_05}"
  R06="\"${SENSOR_06}\":${TEMP_06}"
  R07="\"${SENSOR_07}\":${TEMP_07}"
  R08="\"${SENSOR_08}\":${TEMP_08}"
  R09="\"${SENSOR_09}\":${TEMP_09}"
#  R10="\"${SENSOR_10}\":${TEMP_10}"

  #ROW="{$TS,$R01,$R02,$R03,$R04,$R05,$R06,$R07,$R08,$R09,$R10,$R11}"
  #ROW="{$TS,$R01,$R02,$R03,$R04,$R05,$R06,$R07,$R08,$R09,$R10}"
  ROW="{$TS,$R01,$R02,$R03,$R04,$R05,$R06,$R07,$R08,$R09}"

  mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC -m "$ROW"

  echo >> temperature.log -e "$ROW"

else

  # sudo modprobe w1-gpio pullup=1
  sudo modprobe w1-gpio
  sudo modprobe w1-therm

fi
