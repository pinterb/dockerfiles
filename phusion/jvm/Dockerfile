# phusion-java
#
# VERSION       1.0

FROM pinterb/phusion-base:0.0.2

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
RUN mkdir -p /build
ADD . /build
RUN /build/install.sh
CMD ["/sbin/my_init"]
