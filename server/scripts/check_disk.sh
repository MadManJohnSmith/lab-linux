#!/bin/bash
THRESHOLD=${THRESHOLD:-80}
PARTITION=${PARTITION:-/}
LOG_FILE=/var/log/lab/disk_usage.log
USAGE=$(df -h "$PARTITION" | awk 'NR==2 {gsub("%","",$5); print $5}')
DATE=$(date '+%Y-%m-%d %H:%M:%S')

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "$DATE - ALERTA: Uso de disco en $PARTITION = $USAGE%" >> "$LOG_FILE"
else
    echo "$DATE - OK: Uso de disco en $PARTITION = $USAGE%" >> "$LOG_FILE"
fi
