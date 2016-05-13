FROM pinterb/base:alpine

MAINTAINER Brad Pinter <brad.pinter@gmail.com>

LABEL vendor="Syncthing" \
      net.syncthing.version="0.12.20" \
      net.syncthing.release-date="2016-03-06"

ENV SYNCTHING_VERSION 0.12.20
ENV GLIBC_PKG_VERSION 2.23-r1
ENV USER_GID 5000
ENV USER_UID 5000

RUN apk add --no-cache --update-cache ca-certificates bash sudo openssh-client graphviz && \
  curl -Lo /etc/apk/keys/andyshinn.rsa.pub "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_PKG_VERSION}/andyshinn.rsa.pub" && \
  curl -Lo glibc-${GLIBC_PKG_VERSION}.apk "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_PKG_VERSION}/glibc-${GLIBC_PKG_VERSION}.apk" && \
  curl -Lo glibc-bin-${GLIBC_PKG_VERSION}.apk "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_PKG_VERSION}/glibc-bin-${GLIBC_PKG_VERSION}.apk" && \
  curl -Lo glibc-i18n-${GLIBC_PKG_VERSION}.apk "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_PKG_VERSION}/glibc-i18n-${GLIBC_PKG_VERSION}.apk" && \
  apk add glibc-${GLIBC_PKG_VERSION}.apk glibc-bin-${GLIBC_PKG_VERSION}.apk glibc-i18n-${GLIBC_PKG_VERSION}.apk && \
  curl -Lo /syncthing.tar.gz "https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/syncthing-linux-amd64-v${SYNCTHING_VERSION}.tar.gz" && \
  gunzip /syncthing.tar.gz && tar -xvf /syncthing.tar && \
  mv /syncthing-linux-amd64-v${SYNCTHING_VERSION}/syncthing /tmp/syncthing && \
  rm -rf /syncthing-linux-amd64-v${SYNCTHING_VERSION} && \
  rm -rf /syncthing.tar && \
  apk del --purge curl ca-certificates && \
  rm -rf /var/cache/apk/*

RUN addgroup -g $USER_GID dev && \
    adduser -h /home/dev -u $USER_UID -D -G dev -s /bin/bash dev && \
    mkdir -p /home/dev/bin /home/dev/.ssh && \
    sed -ri 's/(wheel:x:10:root)/\1,dev/' /etc/group && \
    sed -ri 's/# %wheel ALL=\(ALL\) NOPASSWD: ALL/%wheel ALL=\(ALL\) NOPASSWD: ALL/' /etc/sudoers

ENV PATH /home/dev/bin:$PATH

RUN ssh-keygen -t rsa -N '' -f /home/dev/.ssh/dummy_rsa && \
    chown -R dev:dev /home/dev/.ssh

COPY node_id /home/dev/bin/node_id
RUN mv /tmp/syncthing /home/dev/bin/syncthing && \
    chown -R dev:dev /home/dev/bin

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
RUN mkdir /data/ /ops/ /state/ /config/
RUN touch /data/.extra /ops/.extra /state/.extra /config/.extra
RUN chown -R dev:dev /data && \
    chown -R dev:dev /ops && \
    chown -R dev:dev /state && \
    chown -R dev:dev /config

VOLUME ["/data", "/ops", "/state", "/home/dev/.ssh"]
EXPOSE 8080 8384 22000

ENV HOME /home/dev
USER dev
WORKDIR /data

ENTRYPOINT ["/home/dev/bin/syncthing"]
CMD ["-version"]
