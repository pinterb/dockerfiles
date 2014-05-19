#!/bin/bash
set -e
source /build/buildconfig
set -x

## Install Python.
apt-get install -y python python2.7 python3

## install pip
apt-get install -y python-pip python3-pip

## install virtualenv
apt-get install -y python-virtualenv virtualenvwrapper python-tox pbundler
