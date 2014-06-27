#!/bin/bash
set -e
source /build/buildconfig
set -x

## install Go.
wget -P /usr/local https://storage.googleapis.com/golang/go1.2.2.linux-amd64.tar.gz
cd /usr/local && tar -xvzf go1.2.2.linux-amd64.tar.gz && rm /usr/local/go1.2.2.linux-amd64.tar.gz

## Create GOPATH's for root and app users
mkdir /root/gocode && chown root:root /root/gocode
mkdir -p /root/gocode/thirdparty/bin && chown -R root:root /root/gocode/thirdparty/bin
mkdir -p /root/gocode/thirdparty/src && chown -R root:root /root/gocode/thirdparty/src
mkdir -p /root/gocode/thirdparty/pkg && chown -R root:root /root/gocode/thirdparty/pkg

export GOROOT=/usr/local/go
export GOPATH=/root/gocode/thirdparty
export PATH=$PATH:/usr/local/go/bin:/root/gocode/thirdparty/bin

# install third party go apps.
go get github.com/golang/lint/golint

mkdir -p /root/gocode/custom/bin && chown -R root:root /root/gocode/custom/bin
mkdir -p /root/gocode/custom/src && chown -R root:root /root/gocode/custom/src
mkdir -p /root/gocode/custom/pkg && chown -R root:root /root/gocode/custom/pkg

# Handle app user
ret=false
getent passwd app >/dev/null 2>&1 && ret=true

if $ret; then
	mkdir /home/app/gocode && chown root:root /home/app/gocode
	mkdir -p /home/app/gocode/thirdparty/bin && chown -R app:app /home/app/gocode/thirdparty/bin
	mkdir -p /home/app/gocode/thirdparty/src && chown -R app:app /home/app/gocode/thirdparty/src
	mkdir -p /home/app/gocode/thirdparty/pkg && chown -R app:app /home/app/gocode/thirdparty/pkg

	mkdir -p /home/app/gocode/custom/bin && chown -R app:app /home/app/gocode/custom/bin
	mkdir -p /home/app/gocode/custom/src && chown -R app:app /home/app/gocode/custom/src
	mkdir -p /home/app/gocode/custom/pkg && chown -R app:app /home/app/gocode/custom/pkg

	sudo -u app -H sh -c "export GOPATH=/home/app/gocode/thirdparty; \
					export PATH=/usr/local/go/bin:/home/app/gocode/thirdparty/bin:$PATH; \
					go get github.com/golang/lint/golint"
fi
