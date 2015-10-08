FROM debian:jessie

MAINTAINER Brad Pinter <brad.pinter@gmail.com>

ENV GOSU_VERSION 1.6

### apt update, upgrade and install base packages
RUN apt-get update -q && \
 apt-get -y upgrade && \
 apt-get install -y \
 curl && \
 curl -o /usr/local/bin/gosu -L https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64 && \
 chmod +x /usr/local/bin/gosu

CMD []