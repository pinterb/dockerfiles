#!/bin/bash
set -e
source /build/buildconfig
set -x

pip install ansible

ansible --version
