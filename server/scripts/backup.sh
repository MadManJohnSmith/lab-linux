#!/bin/bash
set -e
BACKUP_DIR=/var/backups
DATE=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="$BACKUP_DIR/backup_$DATE.tar.gz"
mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_FILE" \
    /etc \
    /var/log/lab \
    /home 2>/dev/null || true

echo "$(date '+%Y-%m-%d %H:%M:%S') - Respaldo generado: $BACKUP_FILE" \
    >> /var/log/lab/backup.log

# Copiar al directorio de respaldo montado en el host (equivalente a respaldo remoto)
if [ -d /var/backups_host ]; then
    cp "$BACKUP_FILE" /var/backups_host/
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Respaldo copiado a /var/backups_host/" \
        >> /var/log/lab/backup.log
fi
