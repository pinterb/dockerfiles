FROM centos:7

MAINTAINER Brad Pinter <brad.pinter@gmail.com>

ENV GOSU_VERSION 1.6

#RUN yum -y update && \
RUN yum -y install curl && \
 yum clean all && \
 curl -o /usr/local/bin/gosu -L https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64 && \
 chmod +x /usr/local/bin/gosu

CMD []
