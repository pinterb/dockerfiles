# Go with cross compile 
#
# VERSION       1.0

# use the ubuntu base image provided by dotCloud
FROM ubuntu:precise

MAINTAINER Brad Pinter <brad.pinter@gmail.com>

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install wget curl htop vim git mercurial rsync python-software-properties

# golang
RUN hg clone https://code.google.com/p/go
RUN cd /go && hg update go1.1.2

ENV GOROOT /go
ENV GOBIN /go/bin

RUN apt-get install -y gcc g++ make build-essential 

RUN cd /go/src && ./all.bash
ENV PATH $PATH:/go/bin
RUN /bin/bash -c "git clone git://github.com/davecheney/golang-crosscompile.git && source golang-crosscompile/crosscompile.bash && go-crosscompile-build-all"
