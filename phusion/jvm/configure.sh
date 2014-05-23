#!/bin/bash
set -e
source /build/buildconfig
set -x

# Configure java profile.d 
cp /build/config/java.sh /etc/profile.d/java.sh
