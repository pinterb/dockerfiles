#!/bin/bash
set -e
source /build/buildconfig
set -x

## Many Ruby gems and NPM packages contain native extensions and require a compiler.
$minimal_apt_get_install build-essential

## Some data utilities.
$minimal_apt_get_install wget curl rsync tree less unzip

## Misc.
$minimal_apt_get_install locales ntp daemontools

## It's now common to pull dependencies from git or some other VCS.
$minimal_apt_get_install git mercurial bzr subversion
