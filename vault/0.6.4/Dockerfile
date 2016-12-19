FROM vault:0.6.4

MAINTAINER Brad Pinter <brad.pinter@gmail.com>

LABEL vendor="HashiCorp" \
      com.hashicorp.vault.version="0.6.4" \
      com.hashicorp.vault.release-date="2016-12-16"

# Simply expose the config & tls volumes
VOLUME ["/vault/config", "/vault/tls"]

# Add modified entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
