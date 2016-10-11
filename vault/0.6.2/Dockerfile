FROM vault:0.6.2

MAINTAINER Brad Pinter <brad.pinter@gmail.com>

LABEL vendor="HashiCorp" \
      com.hashicorp.vault.version="0.6.2" \
      com.hashicorp.vault.release-date="2016-10-05"

## Expose the config & tls volumes
VOLUME ["/vault/config", "/vault/tls"]
