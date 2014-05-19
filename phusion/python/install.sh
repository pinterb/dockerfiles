#!/bin/bash
set -e
source /build/buildconfig
set -x

/build/enable_repos.sh
/build/prepare.sh
/build/packages.sh
/build/configure.sh
/build/finalize.sh
