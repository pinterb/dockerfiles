#!/bin/bash
set -e
source /build/buildconfig
set -x

### SAMPLE ENTRY ###
# ## Brightbox Ruby 1.9.3, 2.0 and 2.1
# apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C3173AA6
# echo deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main > /etc/apt/sources.list.d/brightbox.list

apt-get update
