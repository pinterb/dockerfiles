# jdk-oracle 
#
# VERSION       1.0

# use the ubuntu base image provided by dotCloud
FROM ubuntu:precise

MAINTAINER Brad Pinter brad.pinter@gmail.com

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install wget curl htop vim git mercurial rsync python-software-properties

RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update && apt-get -y upgrade

# automatically accept oracle license
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
# and install java 7 oracle jdk
RUN apt-get -y install oracle-java7-installer && apt-get clean
RUN update-alternatives --display java 
RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment
ENV PATH $PATH:$JAVA_HOME/bin

# apache maven
RUN cd /opt && wget http://apache.mirrors.tds.net/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
RUN cd /opt && tar -xvf apache-maven-3.0.5-bin.tar.gz 
RUN cd /opt && ln -s apache-maven-3.0.5 maven 
RUN echo "M3_HOME=/opt/maven" >> /etc/environment
RUN echo "M3=$M3_HOME/bin" >> /etc/environment
ENV PATH $PATH:/opt/maven/bin 
