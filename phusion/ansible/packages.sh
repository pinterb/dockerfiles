#!/bin/bash
set -e
source /build/buildconfig
set -x

## install yaml support
apt-get install -y libyaml-dev python-yaml python3-yaml

## install jinja2 support
apt-get install -y python-jinja2 python3-jinja2 python-jinja2-doc
