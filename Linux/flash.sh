#!/bin/bash

# Download luftdaten.info firmware and flash it to NodeMCU device.

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
NOCOLOR="$(tput sgr0)"

USB_DEVICE="$(ls /dev/ttyUSB* 2>/dev/null)"
FIRMWARE_URL="https://www.madavi.de/sensor/update/data/latest_en.bin"
FIRMWARE_FILENAME="$(basename $FIRMWARE_URL)"

# Check if esptool is installed
if command -v esptool 1>/dev/null; then
  echo "Esptool    ${GREEN} OK ${NOCOLOR}"
else
  echo "Esptool    ${RED} NOK: install esptool ${NOCOLOR}"
  sleep 4
  exit 1
fi

# Check if NodeMCU is connected to the computer
if [ -z "${USB_DEVICE}" ]; then
  echo "USB Device ${RED} NOK: device not connected ${NOCOLOR}"
  sleep 4
  exit 1
else
  echo "USB Device ${GREEN} OK ${NOCOLOR} ${USB_DEVICE}"
fi

# Replace the firmware binary
echo "Downloading latest firmware"
curl --remote-name "$FIRMWARE_URL" --progress-bar
echo "Firmware   ${GREEN} OK ${NOCOLOR}"

# Flash the firmware to the ESP8266
echo "Flashing firmware to ${USB_DEVICE}"
if esptool -v -cd nodemcu -cb 57600 -ca 0x00000 -cp ${USB_DEVICE} \
  -cf "./$FIRMWARE_FILENAME"; then
  echo "Flashing   ${GREEN} OK ${NOCOLOR}"
else
  echo "Flashing   ${RED} NOK ${NOCOLOR}"
fi

