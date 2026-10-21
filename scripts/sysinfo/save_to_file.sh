#!/bin/bash

ask_to_save() {

echo -n "Do you want to save this information to a file? (Y/N): "
read answer

if [[ "$answer" == "Y" || "$answer" == "y" ]]; then

FILENAME=$(date +"%d_%m_%y_%H_%M_%S").status

{
echo "HOSTNAME = $HOSTNAME"
echo "TIMEZONE = $TIMEZONE"
echo "USER = $USER"
echo "OS = $OS"
echo "DATE = $DATE"
echo "UPTIME = $UPTIME"
echo "UPTIME_SEC = $UPTIME_SEC"
echo "IP = $IP"
echo "MASK = $MASK"
echo "GATEWAY = $GATEWAY"
echo "RAM_TOTAL = $RAM_TOTAL"
echo "RAM_USED = $RAM_USED"
echo "RAM_FREE = $RAM_FREE"
echo "SPACE_ROOT = $SPACE_ROOT"
echo "SPACE_ROOT_USED = $SPACE_ROOT_USED"
echo "SPACE_ROOT_FREE = $SPACE_ROOT_FREE"
} > "$FILENAME"

echo "Data saved to $FILENAME"
fi
}