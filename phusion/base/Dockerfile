# phusion-base
#
# VERSION       1.0

# use the ubuntu base image provided by phusion
#FROM phusion/baseimage:0.9.10
FROM phusion/passenger-customizable:0.9.10

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
RUN cd /build && ls -ltr && rm -rf * && cd /
RUN rm -rf /build && mkdir /build
ADD . /build
RUN /build/install.sh
CMD ["/sbin/my_init"]
