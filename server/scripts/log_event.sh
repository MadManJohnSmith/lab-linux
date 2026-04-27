#!/bin/bash
MESSAGE="$*"
LOG_FILE=/var/log/lab/events.log
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE - $MESSAGE" >> "$LOG_FILE"
