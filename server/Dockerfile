FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-server \
    sudo \
    cron \
    at \
    rsync \
    rsyslog \
    logrotate \
    vim \
    net-tools \
    iproute2 \
    curl \
    python3 && \
    mkdir -p /var/run/sshd /var/log/lab /var/backups && \
    rm -rf /var/lib/apt/lists/*

# Configurar rsyslog: deshabilitar imklog (no disponible en contenedores), añadir logs del laboratorio
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf && \
    echo 'local0.*    /var/log/lab/syslog' >> /etc/rsyslog.d/50-lab.conf

# Copiar scripts y configuración de cron
COPY scripts/ /opt/lab/scripts/
COPY cron/crontab-root /var/spool/cron/crontabs/root
RUN chmod 600 /var/spool/cron/crontabs/root && \
    chmod +x /opt/lab/scripts/*.sh

# Usuario administrador para el laboratorio
RUN useradd -m -s /bin/bash labadmin && \
    echo "labadmin:Lab@2026!" | chpasswd && \
    usermod -aG sudo labadmin

# Exponer el puerto de servicio del laboratorio
EXPOSE 8080

# Usar el script de entrada (entrypoint)
ENTRYPOINT ["/opt/lab/scripts/entrypoint.sh"]
