# pinterb/phusion-base
#
# VERSION     0.0.7
#
# CREATED ON  2014-08-12T05:31:13CDT

FROM phusion/passenger-customizable:0.9.11

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


### create a user for logging.
RUN addgroup --gid 9998 log && \
 adduser --uid 9998 --gid 9998 --disabled-password --no-create-home --gecos "Logger" log && \
 usermod -L log

### install ntp service (via runit).
RUN apt-get install -y ntp && \
 mkdir /var/run/ntpd

RUN echo "server ntp.okstate.edu" > /etc/ntp.conf && \
    echo "server navobs1.wustl.edu" >> /etc/ntp.conf && \
    echo "server tick.uh.edu" >> /etc/ntp.conf && \
    echo "server ntp.ubuntu.com" >> /etc/ntp.conf && \
    echo "server pool.ntp.org" >> /etc/ntp.conf

RUN mkdir -p /var/log/ntpd && \
    echo "s100000" > /var/log/ntpd/config && \
    echo "n10" >> /var/log/ntpd/config && \
    echo "N5" >> /var/log/ntpd/config && \
    echo "t86400" >> /var/log/ntpd/config && \
    echo "pNTPD_LOG" >> /var/log/ntpd/config

RUN mkdir -p /etc/service/ntpd/log && \
    echo "#!/bin/sh" > /etc/service/ntpd/run && \
    echo "set -e" >> /etc/service/ntpd/run && \
    echo "" >> /etc/service/ntpd/run && \
    echo "exec /usr/sbin/ntpd -u ntp -n -g 2>&1" >> /etc/service/ntpd/run && \
    chmod +x /etc/service/ntpd/run

RUN echo "#!/bin/sh" > /etc/service/ntpd/log/run && \
    echo "set -e" >> /etc/service/ntpd/log/run && \
    echo "" >> /etc/service/ntpd/log/run && \
    echo "exec svlogd -tt /var/log/ntpd/" >> /etc/service/ntpd/log/run && \
    chmod +x /etc/service/ntpd/log/run

### make debian interactive...
RUN env --unset=DEBIAN_FRONTEND

### define default command.
CMD ["/sbin/my_init"]
