#!/bin/bash
set -e
source /build/buildconfig
set -x

## Create a virtualenv environment for app user to use.
mkdir -p /home/app/.virtualenvs
chown app:app /home/app/.virtualenvs
