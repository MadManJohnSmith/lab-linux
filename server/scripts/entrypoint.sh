#!/bin/bash
set -e

# Crear archivos de log si no existen (el bind mount reemplaza /var/log/lab en tiempo de ejecución)
touch /var/log/lab/server.log
touch /var/log/lab/syslog

# Corregir permisos: rsyslog se ejecuta como usuario 'syslog' y necesita acceso de escritura
chown syslog:adm /var/log/lab/syslog
chmod 755 /var/log/lab

# Iniciar el demonio rsyslog directamente (no hay init.d en contenedores mínimos)
rsyslogd

# Iniciar otros servicios
service cron start
service atd start
service ssh start

echo "$(date '+%Y-%m-%d %H:%M:%S') - Servidor iniciado" >> /var/log/lab/server.log

# Registrar evento de arranque en syslog
logger -p local0.info "Servidor de laboratorio iniciado - $(date)"

# Ejecutar inspección de información del sistema al arrancar
/opt/lab/scripts/system_info.sh

# Ejecutar verificación inicial de cuotas
/opt/lab/scripts/check_quotas.sh

# Iniciar servidor HTTP en segundo plano
python3 -m http.server 8080 --directory /var/log/lab &

# Mantener el contenedor en ejecución
tail -f /var/log/lab/server.log
