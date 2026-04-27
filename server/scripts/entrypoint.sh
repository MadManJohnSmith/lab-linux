#!/bin/bash
set -e

# Create log files if they don't exist (bind mount replaces /var/log/lab at runtime)
touch /var/log/lab/server.log
touch /var/log/lab/syslog

# Fix permissions: rsyslog runs as 'syslog' user, needs write access
chown syslog:adm /var/log/lab/syslog
chmod 755 /var/log/lab

# Start rsyslog daemon directly (no init.d in minimal container)
rsyslogd

# Start other services
service cron start
service atd start
service ssh start

echo "$(date '+%Y-%m-%d %H:%M:%S') - Servidor iniciado" >> /var/log/lab/server.log

# Log boot event to syslog
logger -p local0.info "Servidor de laboratorio iniciado - $(date)"

# Run system info inspection on boot
/opt/lab/scripts/system_info.sh

# Run initial quota check
/opt/lab/scripts/check_quotas.sh

# Start HTTP server in background
python3 -m http.server 8080 --directory /var/log/lab &

# Keep container running
tail -f /var/log/lab/server.log
