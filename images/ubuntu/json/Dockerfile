# pinterb/json
#
# VERSION     0.0.10
#
# CREATED ON  2015-01-09T14:31:17CST

FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

# Let's start with some basic stuff.
RUN buildDeps='gcc libc6-dev g++ dpkg-dev libssl-dev make dh-autoreconf'; \
    set -x && \
    apt-get update -qq && apt-get install -y --no-install-recommends \
    $buildDeps \
    adduser \
    sudo \
    apt-transport-https \
    ca-certificates \
    curl \ 
    wget \
    mercurial \
    git \
    vim \
    python-demjson

# Install Go
ENV GO_VERSION 1.4
RUN curl https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz | tar -C /usr/local -zx
ENV GOROOT /usr/local/go
ENV PATH /usr/local/go/bin:$PATH

# Install Jsonnet 
# http://google.github.io/jsonnet/doc/index.html 
ENV JSONNET_VERSION 0.6.0-beta 
RUN git clone https://github.com/google/jsonnet.git /opt/jsonnet && \
    cd /opt/jsonnet && make 
ENV PATH $PATH:/opt/jsonnet

# Install jq
# http://stedolan.github.io/jq/ 
ENV JQ_VERSION 1.4
RUN cd /usr/local/bin && wget http://stedolan.github.io/jq/download/linux64/jq && chmod +x jq

# Install Shopify's ejson
# https://github.com/Shopify/ejson
ENV EJSON_VERSION 1.0.0
ENV EJSON_KEYDIR /opt/ejson/keys
ADD https://github.com/Shopify/ejson/releases/download/$EJSON_VERSION/ejson_$EJSON_VERSION_amd64.deb /tmp/ejson.deb
RUN dpkg -i /tmp/ejson.deb && \
    mkdir -p $EJSON_KEYDIR 

# Done installing, cleanup!
RUN buildDeps='gcc libc6-dev g++ dpkg-dev libssl-dev make dh-autoreconf'; \
    apt-get purge -y --auto-remove $buildDeps

RUN env --unset=DEBIAN_FRONTEND

CMD ["/bin/bash"]
