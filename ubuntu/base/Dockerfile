# ubuntu-base
#
# VERSION       1.0

# use the ubuntu base image provided by dotCloud
FROM stackbrew/ubuntu:14.04

MAINTAINER Brad Pinter brad.pinter@gmail.com

RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    rsync \
    mercurial \
    bzr \
    unzip \
    tree \
    python-pip \
    locales \
    ntp \
    supervisor

RUN dpkg-reconfigure locales && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

# timezone
ADD ntp.conf /etc/ntp.conf
ADD timezone.conf /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

ENV LC_ALL en_US.UTF-8
