#!/bin/bash

check_no_args() {
    if [ "$#" -ne 0 ]
    then
        echo "Error: script must be run without parameters."
        exit 1
    fi
}

collect_system_info() {

HOSTNAME=$(hostname)
TIMEZONE="$(cat /etc/timezone) UTC $(date +%:z)"
USER=$(whoami)

if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS="$NAME, $VERSION"
fi

DATE=$(date +"%d %b %Y %H:%M:%S")

UPTIME=$(uptime -p | sed 's/^up //')
UPTIME_SEC=$(awk '{print $1}' /proc/uptime)

IP=$(hostname -I | awk '{print $1}') #or IP=$(ip route get 8.8.8.8 | awk '{print $7}')
MASK=$(ifconfig | grep -m1 "netmask" | awk '{print $4}')
GATEWAY=$(ip route | awk '/default/ {print $3}')

RAM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{printf "%.3f GB", $2/1024/1024}')
RAM_FREE=$(awk '/MemFree/ {printf "%.3f GB", $2/1024/1024}' /proc/meminfo)
RAM_USED=$(awk '
/MemTotal/ {total=$2}
/MemAvailable/ {free=$2}
END {printf "%.3f GB", (total-free)/1024/1024}
' /proc/meminfo)

SPACE_ROOT=$(df -m / | tail -1 | awk '{printf "%.2f MB", $2}')
SPACE_ROOT_USED=$(df -m / | tail -1 | awk '{printf "%.2f MB", $3}')
SPACE_ROOT_FREE=$(df -m / | tail -1 | awk '{printf "%.2f MB", $4}')
}

print_system_info() {
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
}