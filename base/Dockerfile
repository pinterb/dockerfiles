# Base 
#
# VERSION       1.0

# use the ubuntu base image provided by dotCloud
FROM stackbrew/ubuntu:trusty

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
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

# timezone
ADD ntp.conf /etc/ntp.conf
ADD timezone.conf /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

ENV LC_ALL C.UTF-8

# TODO: Set up a supervisor conf to run ntp, your apps, etc.
