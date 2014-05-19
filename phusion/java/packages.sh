#!/bin/bash
set -e
source /build/buildconfig
set -x

## Install Java.
apt-get install -y oracle-java8-installer
apt-get install -y oracle-java8-set-default
# update-java-alternatives -s java-8-oracle
