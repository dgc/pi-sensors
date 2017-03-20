#!/usr/bin/env python2.7

import RPi.GPIO as GPIO
import time
import json
import re

temp_sensors = ["28-000006dd5bbd", "28-000006ddbe63", "28-00000722cf9d", "28-000007486f53"]


PERIOD = 60

GPIO.setmode(GPIO.BCM)

last_sensor0 = 0
last_sensor1 = 0

sensor0 = 0
sensor1 = 0

def inc_sensor0(channel):
    global sensor0
    sensor0 = sensor0 + 1

def inc_sensor1(channel):
    global sensor1
    sensor1 = sensor1 + 1

GPIO.setup(17, GPIO.IN)
GPIO.setup(23, GPIO.IN)

GPIO.add_event_detect(17, GPIO.FALLING, callback=inc_sensor0, bouncetime=50)
GPIO.add_event_detect(23, GPIO.FALLING, callback=inc_sensor1, bouncetime=50)

def wait_for_interval(period):

    # Based on http://stackoverflow.com/a/19645797

    current_time = time.time()
    time_to_sleep = period - (current_time % period)
    time.sleep(time_to_sleep)

try:
    wait_for_interval(PERIOD)

    last_sensor0 = sensor0
    last_sensor1 = sensor1

    while True:

        wait_for_interval(PERIOD)

        msg = { "sensor0": sensor0 - last_sensor0, "sensor1": sensor1 - last_sensor1 }

        for sensor_id in temp_sensors:

            with open("/sys/bus/w1/devices/" + sensor_id + "/w1_slave") as f:
                content = f.readlines()
                msg[sensor_id] = int(re.sub(r".*t=", "", content[1].strip()))
            time.sleep(1)

        msg["timestamp"] = int(time.time())

        print json.dumps(msg, sort_keys=True)

        last_sensor0 = sensor0
        last_sensor1 = sensor1

except KeyboardInterrupt:
    GPIO.cleanup()       # clean up GPIO on CTRL+C exit

GPIO.cleanup()           # clean up GPIO on normal exit
