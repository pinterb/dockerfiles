#!/bin/bash
set -e
source /build/buildconfig
set -x

# Configure python's virtualenv
cp /build/config/python.sh /etc/profile.d/python.sh
