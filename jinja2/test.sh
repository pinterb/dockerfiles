#!/bin/bash

# vim: filetype=sh:tabstop=2:shiftwidth=2:expandtab


docker run -i \
  -v ${PWD}:/data \
  -v /home/pinterb:/out \
  -e TEMPLATE=some.json.j2 \
  -e OUT_FILE=/out/some.json \
  -e PGID=$(id -g) -e PUID=$(id -u) \
  pinterb/jinja2:0.0.15 datacenter='msp' acl_ttl='3m'

docker run -i \
  -v ${PWD}:/data \
  -v /tmp:/out \
  -e OUT_FILE=/out/some.json \
  -e TEMPLATE=some.json.j2 \
  -e PGID=$(id -g) -e PUID=$(id -u) \
  pinterb/jinja2:0.0.15 datacenter='msp' acl_ttl='33m'

