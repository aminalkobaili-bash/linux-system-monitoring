#!/bin/bash

OUTPUT="${OUTPUT:-/var/www/html/metrics}"

# CPU usage is computed from /proc/stat deltas between iterations.
# The original version parsed `top -bn1` with awk '$8': at 100% idle top prints
# "0.0 ni,100.0 id" without a space, $8 became "id," and the script reported 100% CPU.
read_cpu() {
    # fields: user nice system idle iowait irq softirq steal (guest is already counted in user)
    awk '/^cpu / {total = $2+$3+$4+$5+$6+$7+$8+$9; idle = $5+$6; print total, idle}' /proc/stat
}

read -r PREV_TOTAL PREV_IDLE < <(read_cpu)

while true
do

sleep 3

read -r TOTAL IDLE < <(read_cpu)
CPU_USAGE=$(awk -v dt=$((TOTAL - PREV_TOTAL)) -v di=$((IDLE - PREV_IDLE)) \
    'BEGIN { if (dt > 0) printf "%.1f", (dt - di) * 100 / dt; else print 0 }')
PREV_TOTAL=$TOTAL
PREV_IDLE=$IDLE

MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')

DISK_FREE=$(df / | awk 'NR==2 {print $4}')

cat << EOF > $OUTPUT
# HELP custom_cpu_usage CPU usage
# TYPE custom_cpu_usage gauge
custom_cpu_usage $CPU_USAGE

# HELP custom_memory_used Memory used
# TYPE custom_memory_used gauge
custom_memory_used $MEM_USED

# HELP custom_memory_total Memory total
# TYPE custom_memory_total gauge
custom_memory_total $MEM_TOTAL

# HELP custom_disk_free Disk free space
# TYPE custom_disk_free gauge
custom_disk_free $DISK_FREE
EOF

done
