#!/bin/bash
set -e
source /build/buildconfig
set -x

# configure /etc/provile.d/ with golang info
cp /build/config/go.sh /etc/profile.d/go.sh
