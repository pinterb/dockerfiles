# phusion-base
#
# VERSION      0.0.2

FROM phusion/passenger-customizable:0.9.10

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

### enable repos and update
RUN apt-get update -q


### prepare system

# Create a user for logging.
RUN addgroup --gid 9998 log
RUN adduser --uid 9998 --gid 9998 --disabled-password --no-create-home --gecos "Logger" log
RUN usermod -L log


### install packages
RUN apt-get install -y --no-install-recommends build-essential \
    wget curl rsync tree less unzip \
    locales ntp daemontools \
    git mercurial bzr subversion


### configure
RUN mkdir -p /build
ADD . /build

# timezone
RUN cp /build/config/ntp.conf /etc/ntp.conf
RUN cp /build/config/timezone.conf /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Install ntp runit service.
RUN mkdir -p /var/log/ntpd/
RUN cp /build/config/ntp-sylogd.conf /var/log/ntpd/config

RUN mkdir -p /etc/service/ntpd/log
RUN cp /build/runit/ntp /etc/service/ntpd/run
RUN cp /build/runit/log /etc/service/ntpd/log/run

RUN mkdir /var/run/ntpd


### finalize build
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm -rf /build/runit/* /build/config/* /build/test/*
RUN rm -rf /build/test
RUN rm -f /build/{Dockerfile,README.md,buildconfig,insecure_key*}


### run our init
CMD ["/sbin/my_init"]
