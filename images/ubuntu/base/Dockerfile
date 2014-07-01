# pinterb/ubuntu-base
#
# VERSION     0.0.5
#
# CREATED ON  2014-07-01T10:21:58CDT

FROM ubuntu:14.04

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive

### apt update, upgrade and install base packages
RUN apt-get update -q && \
 apt-get -y upgrade && \
 apt-get install -y \
 build-essential \
 software-properties-common \
 language-pack-en \
 socat \
 python-software-properties python-setuptools python-pip python-all-dev \
 byobu curl htop unzip vim wget rsync tree less \
 locales daemontools cron \
 git mercurial bzr subversion

### create a user for whatever application we choose to run.
RUN addgroup --gid 9999 app && \
 adduser --uid 9999 --gid 9999 --disabled-password --gecos "Application" app && \
 usermod -L app && \
 mkdir -p /home/app/.ssh && \
 chmod 700 /home/app/.ssh && \
 chown app:app /home/app/.ssh

### create a user for logging.
RUN addgroup --gid 9998 log && \
 adduser --uid 9998 --gid 9998 --disabled-password --no-create-home --gecos "Logger" log && \
 usermod -L log

### make debian interactive...
RUN env --unset=DEBIAN_FRONTEND

### define default command.
CMD ["/bin/bash"]
