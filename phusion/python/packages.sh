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

## install Sphinx documentation tools
apt-get install -y python-sphinx python3-sphinx python-docutils python3-docutils

## install more Sphinx documentation tools
apt-get install -y python-sphinx.issuetracker python-sphinxcontrib-httpdomain python-sphinxcontrib.blockdiag python-sphinxcontrib.nwdiag python-sphinxcontrib.seqdiag python-sphinxcontrib.spelling python-sphinxcontrib-docbookrestapi
