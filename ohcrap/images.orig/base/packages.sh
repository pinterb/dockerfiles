#!/bin/bash
set -e
source /build/buildconfig
set -x

apt-get update -q && \
apt-get -y upgrade && \
apt-get install -y build-essential && \
apt-get install -y software-properties-common && \
apt-get install -y language-pack-en && \
apt-get install -y byobu curl htop unzip vim wget rsync tree less && \
apt-get install -y locales daemontools cron && \
apt-get install -y git mercurial bzr subversion
