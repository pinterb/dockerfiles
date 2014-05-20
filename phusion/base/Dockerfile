# phusion-base
#
# VERSION       1.0

FROM phusion/passenger-customizable:0.9.10

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
RUN mkdir -p /build
ADD . /build
RUN /build/install.sh
RUN echo HELLO
CMD ["/sbin/my_init"]
