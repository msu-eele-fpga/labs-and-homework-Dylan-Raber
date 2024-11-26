#!/bin/bash
HPS_LED_CONTROL="/sys/devices/platform/ff200000.led_patterns/hps_led_control"
BASE_PERIOD="/sys/devices/platform/ff200000.led_patterns/base_period"
LED_REG="/sys/devices/platform/ff200000.led_patterns/led_reg"

while true
do
    echo 0x70 > $BASE_PERIOD
    sleep 3
    echo 0xA0 > $BASE_PERIOD
    sleep 3
done