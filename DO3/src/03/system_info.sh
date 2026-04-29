#!/bin/bash

print_line() {
    echo -e "\033[${NAME_BG};${NAME_FG}m$1\033[0m = \033[${VALUE_BG};${VALUE_FG}m$2\033[0m"
}

print_system_info() {

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

    IP=$(hostname -I | awk '{print $1}')
    MASK=$(ifconfig | grep -m1 "netmask" | awk '{print $4}')
    GATEWAY=$(ip route | awk '/default/ {print $3}')

    RAM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{printf "%.3f GB", $2/1024/1024}')
    RAM_FREE=$(awk '/MemFree/ {printf "%.3f GB", $2/1024/1024}' /proc/meminfo)

    RAM_USED=$(awk '
        /MemTotal/ {total=$2}
        /MemAvailable/ {free=$2}
        END {printf "%.3f GB", (total-free)/1024/1024}
    ' /proc/meminfo)

    SPACE_ROOT=$(df -m / | awk 'NR==2 {printf "%.2f MB", $2}')
    SPACE_ROOT_USED=$(df -m / | awk 'NR==2 {printf "%.2f MB", $3}')
    SPACE_ROOT_FREE=$(df -m / | awk 'NR==2 {printf "%.2f MB", $4}')

    print_line "HOSTNAME" "$HOSTNAME"
    print_line "TIMEZONE" "$TIMEZONE"
    print_line "USER" "$USER"
    print_line "OS" "$OS"
    print_line "DATE" "$DATE"
    print_line "UPTIME" "$UPTIME"
    print_line "UPTIME_SEC" "$UPTIME_SEC"
    print_line "IP" "$IP"
    print_line "MASK" "$MASK"
    print_line "GATEWAY" "$GATEWAY"
    print_line "RAM_TOTAL" "$RAM_TOTAL"
    print_line "RAM_USED" "$RAM_USED"
    print_line "RAM_FREE" "$RAM_FREE"
    print_line "SPACE_ROOT" "$SPACE_ROOT"
    print_line "SPACE_ROOT_USED" "$SPACE_ROOT_USED"
    print_line "SPACE_ROOT_FREE" "$SPACE_ROOT_FREE"
}