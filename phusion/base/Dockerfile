# phusion-base
#
# VERSION       1.0

# use the ubuntu base image provided by phusion
FROM phusion/baseimage:0.9.10

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
RUN mkdir /build
ADD . /build
RUN /build/install.sh
CMD ["/sbin/my_init"]
