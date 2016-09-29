#!/bin/bash

# vim: filetype=sh:tabstop=2:shiftwidth=2:expandtab
# strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

#
# Define default Variables.
#
USER="dev"
GROUP="dev"

SH_C='sudo -E sh -c'

UID_ACTUAL=$(id -u ${USER})
GID_ACTUAL=$(id -g ${GROUP})

UID_NAMED=${PUID:-1000}
GID_NAMED=${PGID:-1000}

# Check if the configuration directory option has been set
containsConfig () {
    local e
    for e in "${@:1}"; do
        [[ "$e" == "-home" ]] && return 0
    done
    return 1
}

# if this if the first run, generate a useful config
if [ ! -f /config/config.xml ]; then
  echo "generating config"
  /bin/syncthing --generate="/config"
  # generating as root will create a default folder of /root/Sync, replace it with our /data directory
  sed -e "s#path=\"/root/Sync/\"#path=\"/data/default/\"#" -i /config/config.xml
  # ensure we can see the web ui outside of the docker container
  sed -e "s/<address>127.0.0.1:8384/<address>0.0.0.0:8384/" -i /config/config.xml
fi

#
# Display settings on standard out.
#
echo ""
echo "named settings"
echo "=============="
echo ""
echo "  Username:        ${USER}"
echo "  Groupname:       ${GROUP}"
echo "  UID actual:      ${UID_ACTUAL}"
echo "  GID actual:      ${GID_ACTUAL}"
echo "  UID preferred:   ${UID_NAMED}"
echo "  GID preferred:   ${GID_NAMED}"
echo ""

#
# Change UID / GID of named user.
#
if [[ "$UID_NAMED" -ne 0 ]]; then
  echo "Updating UID / GID... "
  if [[ "$UID_ACTUAL" -ne "$UID_NAMED" || "$GID_ACTUAL" -ne "$GID_NAMED" ]]; then
    echo "  * Change user / group"
    deluser "$USER"
    addgroup -g "$GID_NAMED" "$GROUP"
    adduser -u "$UID_NAMED" -D -H -G "$GROUP" -h /config -s /bin/bash "$USER"
    echo "    - user / group changed."

    echo "  * Set owner and permissions for old uid/gid files"
    find / -user "$UID_ACTUAL" -exec chown "$USER" {} \;
    find / -user "$GID_ACTUAL" -exec chown "$GROUP" {} \;
    echo "    - file permissions changed."
  else
    echo "  * UID & GID matched...nothing to do."
    chown -R "$USER":"$GROUP" /config /data /state /ops
  fi
fi

if ! containsConfig "$@"; then
  echo "Config directory not set.  Setting it now..."
  set -- -home /config \
  "$@"
fi

# run syncthing
if [[ "$UID_NAMED" -eq 0 ]]; then
  /bin/syncthing "$@"
else
  sudo -E --user "$USER" /bin/syncthing "$@"
fi