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
ENV GOPATH /go/gocode

RUN mkdir $GOPATH
RUN mkdir $GOPATH/pkg
RUN mkdir $GOPATH/bin
RUN mkdir $GOPATH/src

RUN apt-get install -y gcc g++ make build-essential 

RUN cd /go/src && ./all.bash
ENV PATH $PATH:/go/bin

# install goxc
RUN go get github.com/laher/goxc
