#!/bin/bash
set -e
source /build/buildconfig
set -x

sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list
