#!/bin/bash
set -e
source /build/buildconfig
set -x

rm -rf /build/runit/* /build/config/* /build/test/*
rm -rf /build/test
rm -rf /build/config
rm -rf /build/runit
rm -f /build/{Dockerfile,README.md,buildconfig,insecure_key*,*.sh}

env --unset=DEBIAN_FRONTEND
