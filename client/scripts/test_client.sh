#!/bin/bash
set -e
SERVER_HOST=${SERVER_HOST:-server}
SERVER_PORT=${SERVER_PORT:-8080}

echo "[CLIENTE] Probando conectividad hacia $SERVER_HOST:$SERVER_PORT"

# Esperar a que el servidor esté listo
echo "[CLIENTE] Esperando a que el servidor esté listo..."
for i in $(seq 1 30); do
    if curl -s -o /dev/null -w "%{http_code}" "http://$SERVER_HOST:$SERVER_PORT" 2>/dev/null | grep -q "200"; then
        echo "[CLIENTE] Servidor listo después de ${i}s"
        break
    fi
    sleep 1
done

echo ""
echo "=== Prueba de ping ==="
ping -c 3 "$SERVER_HOST" || echo "No se puede hacer ping a $SERVER_HOST"

echo ""
echo "=== Prueba de conexión HTTP ==="
if command -v curl >/dev/null 2>&1; then
    curl -v "http://$SERVER_HOST:$SERVER_PORT" 2>&1 || echo "No se pudo establecer conexión HTTP"
else
    echo "curl no está disponible en el contenedor cliente"
fi

echo ""
echo "[CLIENTE] Pruebas finalizadas."

# Mantener el contenedor en ejecución para inspección
echo "[CLIENTE] Contenedor en espera para inspección..."
sleep infinity
