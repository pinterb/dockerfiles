#!/bin/bash
set -e
source /build/buildconfig
set -x

# Example preparation
# ## Create a user for logging.
# addgroup --gid 9998 log
# adduser --uid 9998 --gid 9998 --disabled-password --no-create-home --gecos "Logger" log
# usermod -L log
