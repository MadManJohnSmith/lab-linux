#!/bin/bash
# check_quotas.sh - Equivalente de cuotas de disco para contenedores
# En contenedores Docker las cuotas tradicionales (quota/edquota) no están disponibles
# porque el sistema de archivos es administrado por el host.
# Este script implementa un control de cuotas por software.

QUOTA_LIMIT_MB=${QUOTA_LIMIT_MB:-100}  # Límite por defecto: 100 MB por usuario
LOG_FILE=/var/log/lab/quotas.log
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "$DATE - === Verificación de cuotas de disco ===" >> "$LOG_FILE"

# Recorrer todos los directorios home de usuarios
for user_home in /home/*/; do
    if [ -d "$user_home" ]; then
        username=$(basename "$user_home")
        # Calcular uso en MB
        usage_kb=$(du -sk "$user_home" 2>/dev/null | awk '{print $1}')
        usage_mb=$((usage_kb / 1024))
        limit_mb=$QUOTA_LIMIT_MB

        if [ "$usage_mb" -ge "$limit_mb" ]; then
            echo "$DATE - ALERTA CUOTA: Usuario '$username' usa ${usage_mb}MB de ${limit_mb}MB permitidos en $user_home" >> "$LOG_FILE"
            # Opción: bloquear escritura cambiando permisos
            # chmod 555 "$user_home"
            # echo "$DATE - ACCIÓN: Escritura bloqueada para $username" >> "$LOG_FILE"
        else
            echo "$DATE - OK CUOTA: Usuario '$username' usa ${usage_mb}MB de ${limit_mb}MB permitidos" >> "$LOG_FILE"
        fi
    fi
done

echo "$DATE - === Fin verificación de cuotas ===" >> "$LOG_FILE"
