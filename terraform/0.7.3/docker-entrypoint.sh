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

#if [ ! "$(id -u dev)" -eq "$PUID" ]; then usermod -o -u "$PUID" dev ; fi
#if [ ! "$(id -g dev)" -eq "$PGID" ]; then groupmod -o -g "$PGID" dev ; fi

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
fi
echo ""
echo ""


# run terraform 
sudo -E --user "$USER" /bin/terraform "$@"
