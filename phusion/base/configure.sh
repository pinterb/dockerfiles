#!/bin/bash
set -e
source /build/buildconfig
set -x

# timezone
cp /build/config/ntp.conf /etc/ntp.conf
cp /build/config/timezone.conf /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

## Install ntp runit service.
mkdir -p /var/log/ntpd/
cp /build/config/ntp-sylogd.conf /var/log/ntpd/config

mkdir -p /etc/service/ntpd/log
cp /build/runit/ntp /etc/service/ntpd/run
cp /build/runit/log /etc/service/ntpd/log/run
touch /etc/service/ntpd/down
