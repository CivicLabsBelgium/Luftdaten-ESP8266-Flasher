#!/bin/bash

RED=`tput setaf 1`
GREEN=`tput setaf 2`
NOCOLOR=`tput sgr0`

# this checks if you have Arduino installed or not
if open -Ra "Arduino" ; then
  echo "Arduino   ${GREEN} OK ${NOCOLOR}"
else
  echo "Arduino      ${RED} NOK : install arduino IDE ${NOCOLOR}"
  exit 1
fi

# this checks if you have your ESP tools installed
if [ ! -f ~/Library/Arduino15/packages/esp8266/tools/esptool/0.4.9/esptool ]; then
  echo "Esptool ${RED} NOK : install esp8266 tooling via the Arduino board manager ${NOCOLOR}"
  exit 1
else
  echo "Esptool   ${GREEN} OK ${NOCOLOR}"
fi

# this checks if you have a Nodemcu connected to your computer
# it creates a variable of the name of your serial port if it finds it
USBD="$( ls /dev/cu.wchusbserial* 2>/dev/null)"

if [ -z "${USBD}" ]; then
  echo "USB Device${RED} NOK ${NOCOLOR}"
  exit 1
else
  echo "USB Device${GREEN} OK ${NOCOLOR} ${USBD}"
fi

# flashing the firmware to the ESP8266
echo "Requestig the chip Id of the ESP on port ${USBD}"
~/Library/Arduino15/packages/esp8266/tools/esptool/0.4.9/esptool --port ${USBD} chip_id
