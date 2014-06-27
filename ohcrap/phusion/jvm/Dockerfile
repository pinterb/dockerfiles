# phusion-jvm
#
# VERSION      0.0.3

FROM pinterb/phusion-base:0.0.3

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

### enable repos and update
RUN \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
 echo deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main > /etc/apt/sources.list.d/webupd8team-java.list && \
 echo deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main >> /etc/apt/sources.list.d/webupd8team-java.list && \
 apt-get update -q && \
 echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections


### install packages
# install Java.
RUN apt-get install -y oracle-java8-installer oracle-java8-set-default
#RUN apt-get install -y oracle-java8-set-default
RUN update-alternatives --display java


### configure


### finalize build
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


### run our init
CMD ["/sbin/my_init"]
