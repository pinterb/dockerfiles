#!/bin/bash
set -e
source /build/buildconfig
set -x

## webupd8team/java
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
echo deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main > /etc/apt/sources.list.d/webupd8team-java.list
echo deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main >> /etc/apt/sources.list.d/webupd8team-java.list

apt-get update

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
