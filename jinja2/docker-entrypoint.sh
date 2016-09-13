#!/bin/bash

# vim: filetype=sh:tabstop=2:shiftwidth=2:expandtab

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

#
# Display settings on standard out.
#
#echo ""
#echo "named settings"
#echo "=============="
#echo ""
#echo "  Username:        ${USER}"
#echo "  Groupname:       ${GROUP}"
#echo "  UID actual:      ${UID_ACTUAL}"
#echo "  GID actual:      ${GID_ACTUAL}"
#echo "  UID preferred:   ${UID_NAMED}"
#echo "  GID preferred:   ${GID_NAMED}"
#echo ""

#
# Change UID / GID of named user.
#
if [[ "$UID_NAMED" -ne 0 ]]; then
  if [[ "$UID_ACTUAL" -ne "$UID_NAMED" || "$GID_ACTUAL" -ne "$GID_NAMED" ]]; then
    deluser "$USER"
    addgroup -g "$GID_NAMED" "$GROUP"
    adduser -u "$UID_NAMED" -D -H -G "$GROUP" -h /config -s /bin/bash "$USER"

    find / -user "$UID_ACTUAL" -exec chown "$USER" {} \;
    find / -user "$GID_ACTUAL" -exec chown "$GROUP" {} \;
  fi
fi

# run jinga2 rendering script 
if [[ "$UID_NAMED" -eq 0 ]]; then
  if [ -n "$OUT_FILE" ]; then
    /home/dev/bin/render.py "$@" > "$OUT_FILE"
  else
    /home/dev/bin/render.py "$@"
  fi
else
  if [ -n "$OUT_FILE" ]; then
    sudo -E --user "$USER" /home/dev/bin/render.py "$@" > "$OUT_FILE"
    chown "$USER":"$GROUP" "$OUT_FILE"
  else
    sudo -E --user "$USER" /home/dev/bin/render.py "$@"
  fi
fi
