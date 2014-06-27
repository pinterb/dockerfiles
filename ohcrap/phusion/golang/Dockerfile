# phusion-golang
#
# VERSION      0.0.3

FROM pinterb/phusion-base:0.0.3

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

### install packages
# install Go.
RUN wget -P /usr/local https://storage.googleapis.com/golang/go1.2.2.linux-amd64.tar.gz
RUN cd /usr/local && tar -xvzf go1.2.2.linux-amd64.tar.gz && rm /usr/local/go1.2.2.linux-amd64.tar.gz
RUN mkdir -p /usr/local/golangthirdparty/bin && chown -R root:root /usr/local/golangthirdparty/bin
RUN mkdir -p /usr/local/golangthirdparty/src && chown -R root:root /usr/local/golangthirdparty/src
RUN mkdir -p /usr/local/golangthirdparty/pkg && chown -R root:root /usr/local/golangthirdparty/pkg

ENV GOPATH /usr/local/golangthirdparty
ENV GOROOT /usr/local/go
ENV PATH $PATH:/usr/local/go/bin:/usr/local/golangthirdparty/bin

RUN mkdir /root/gocode && chown root:root /root/gocode
RUN mkdir -p /root/gocode/bin && chown -R root:root /root/gocode/bin
RUN mkdir -p /root/gocode/src && chown -R root:root /root/gocode/src
RUN mkdir -p /root/gocode/pkg && chown -R root:root /root/gocode/pkg

# install third party go apps.
RUN go get github.com/golang/lint/golint


### configure
RUN mkdir -p /build
ADD . /build

# configure /etc/provile.d/ with java info
RUN cp /build/config/go.sh /etc/profile.d/go.sh


### finalize build
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm -rf /build/config/*
RUN rm -rf /build/test/*
RUN rm -rf /build/test
RUN rm -f /build/{Dockerfile,README.md,buildconfig,insecure_key*}


### run our init
CMD ["/sbin/my_init"]
