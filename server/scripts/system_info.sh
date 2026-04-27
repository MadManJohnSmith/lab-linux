#!/bin/bash
# system_info.sh - Información del sistema, kernel y proceso de arranque
# Documenta el proceso de arranque, niveles de operación y estado del kernel

LOG_FILE=/var/log/lab/system_info.log
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "=============================================" >> "$LOG_FILE"
echo "$DATE - Inspección del sistema" >> "$LOG_FILE"
echo "=============================================" >> "$LOG_FILE"

echo "" >> "$LOG_FILE"
echo "=== 1. Información del Kernel ===" >> "$LOG_FILE"
uname -a >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "=== 2. Versión del Sistema Operativo ===" >> "$LOG_FILE"
cat /etc/os-release >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "=== 3. Proceso de arranque - Procesos activos (PID 1 y servicios) ===" >> "$LOG_FILE"
ps aux --sort=pid | head -20 >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "=== 4. Niveles de operación (Runlevels / Systemd targets) ===" >> "$LOG_FILE"
# En contenedores no hay systemd, pero podemos documentar el equivalente
echo "Nota: En contenedores Docker, PID 1 es el entrypoint (no systemd/init)." >> "$LOG_FILE"
echo "Los servicios se inician manualmente en el entrypoint.sh:" >> "$LOG_FILE"
echo "  1. cron (tareas programadas)" >> "$LOG_FILE"
echo "  2. atd (tareas de ejecución diferida)" >> "$LOG_FILE"
echo "  3. sshd (acceso remoto SSH)" >> "$LOG_FILE"
echo "  4. rsyslogd (sistema de logging)" >> "$LOG_FILE"
echo "  5. python3 http.server (servicio web en puerto 8080)" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Runlevel actual (si disponible):" >> "$LOG_FILE"
runlevel >> "$LOG_FILE" 2>&1 || echo "  runlevel no disponible (contenedor sin init)" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "=== 5. Servicios activos ===" >> "$LOG_FILE"
service --status-all >> "$LOG_FILE" 2>&1 || echo "  service --status-all no disponible" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "=== 6. Información de CPU ===" >> "$LOG_FILE"
cat /proc/cpuinfo | head -20 >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "=== 7. Información de Memoria ===" >> "$LOG_FILE"
free -h >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "=== 8. Sistemas de archivos montados ===" >> "$LOG_FILE"
df -hT >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "=== 9. Puntos de montaje ===" >> "$LOG_FILE"
mount | grep -E "(ext4|overlay|tmpfs|volume)" >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "=== 10. Volúmenes Docker (vistos desde el contenedor) ===" >> "$LOG_FILE"
echo "  /var/backups     -> Docker named volume (server_backups)" >> "$LOG_FILE"
echo "  /var/log/lab     -> Bind mount (./data/logs)" >> "$LOG_FILE"
echo "  /var/backups_host -> Bind mount (./data/backups)" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "$DATE - Inspección completada" >> "$LOG_FILE"
