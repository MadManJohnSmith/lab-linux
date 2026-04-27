FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    iputils-ping \
    net-tools \
    openssh-client && \
    rm -rf /var/lib/apt/lists/*

COPY scripts/test_client.sh /opt/lab/test_client.sh
RUN chmod +x /opt/lab/test_client.sh
CMD ["/opt/lab/test_client.sh"]
