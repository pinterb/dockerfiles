#!/bin/sh

# managed by docker
export M3_HOME=/usr/local/maven/latest
export M3=$M3_HOME/bin
export MAVEN_OPTS="-Xms256m -Xmx512m"
export PATH=$M3:$PATH
