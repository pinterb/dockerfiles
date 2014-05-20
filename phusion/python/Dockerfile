# phusion-python
#
# VERSION       1.0

FROM pinterb/phusion-base

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
RUN mkdir -p /build
ADD . /build
RUN /build/install.sh
CMD ["/sbin/my_init"]
