#!/bin/bash

OUTPUT="/var/www/html/metrics"

while true
do

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

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

sleep 3

done