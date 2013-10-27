# Base 
#
# VERSION       1.0

# use the ubuntu base image provided by dotCloud
FROM ubuntu:precise

MAINTAINER Brad Pinter brad.pinter@gmail.com

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y wget curl htop vim git mercurial rsync ntp python-software-properties supervisor

# timezone
ADD ntp.conf /etc/ntp.conf
ADD timezone.conf /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

# TODO: Set up a supervisor conf to run ntp, your apps, etc.
