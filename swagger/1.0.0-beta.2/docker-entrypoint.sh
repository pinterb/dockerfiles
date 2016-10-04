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

DEBUG=${DEBUG:-0}

# Debug function
# Usage: dbug message in parts 
function dbug {
  if [ $DEBUG -eq 1 ];
  then
    echo "$@"
  fi
}

#
# Display settings on standard out.
#
dbug ""
dbug "named settings"
dbug "=============="
dbug ""
dbug "  Username:        ${USER}"
dbug "  Groupname:       ${GROUP}"
dbug "  UID actual:      ${UID_ACTUAL}"
dbug "  GID actual:      ${GID_ACTUAL}"
dbug "  UID preferred:   ${UID_NAMED}"
dbug "  GID preferred:   ${GID_NAMED}"
dbug ""

#
# Change UID / GID of named user.
#
dbug "Updating UID / GID... "
if [[ "$UID_ACTUAL" -ne "$UID_NAMED" || "$GID_ACTUAL" -ne "$GID_NAMED" ]]; then
  dbug "  * Change user / group"
  deluser "$USER"
  addgroup -g "$GID_NAMED" "$GROUP"
  adduser -u "$UID_NAMED" -D -H -G "$GROUP" -h /config -s /bin/bash "$USER"
  dbug "    - user / group changed."

  dbug "  * Set owner and permissions for old uid/gid files"
  find / -user "$UID_ACTUAL" -exec chown "$USER" {} \;
  find / -user "$GID_ACTUAL" -exec chown "$GROUP" {} \;
  dbug "    - file permissions changed."
else
  dbug "  * UID & GID matched...nothing to do."
fi
dbug ""
dbug ""


# run swagger-cli 
sudo --user "$USER" /usr/bin/swagger "$@"
