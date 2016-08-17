FROM pinterb/base:alpine
MAINTAINER Brad Pinter "brad.pinter@gmail.com"

# This is the release of Swagger 2.0 cli to pull in.
LABEL vendor="BigstickCarpet" \
      com.bigstickcarpet.swagger-cli.version="1.0.0-beta.2" \
      com.bigstickcarpet.swagger-cli.release-date="2015-09-29"

ENV USER_GID 1000
ENV USER_UID 1000

RUN apk --update add --no-cache nodejs ca-certificates bash sudo openssh-client && \
  npm install -g swagger-cli  && \
  rm -rf /var/cache/apk/*
  
RUN addgroup -g $USER_GID dev && \
    adduser -h /home/dev -u $USER_UID -D -G dev -s /bin/bash dev && \
    mkdir -p /home/dev/bin /home/dev/.ssh && \
    sed -ri 's/(wheel:x:10:root)/\1,dev/' /etc/group && \
    sed -ri 's/# %wheel ALL=\(ALL\) NOPASSWD: ALL/%wheel ALL=\(ALL\) NOPASSWD: ALL/' /etc/sudoers

ENV PATH /home/dev/bin:$PATH

RUN ssh-keygen -t rsa -N '' -f /home/dev/.ssh/dummy_rsa && \
    chown -R dev:dev /home/dev/.ssh /home/dev/bin

RUN apk del --purge curl ca-certificates && \
  rm -rf /var/cache/apk/*

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
RUN mkdir /data/ /output/ /state/ /config/
RUN touch /data/.extra /output/.extra /state/.extra /config/.extra
RUN chown -R dev:dev /data && \
    chown -R dev:dev /output && \
    chown -R dev:dev /state && \
    chown -R dev:dev /config

VOLUME ["/data", "/output", "/state", "/home/dev/.ssh"]
EXPOSE 8080

ENV HOME /home/dev
USER dev
WORKDIR /data

ENTRYPOINT ["/usr/bin/swagger"]
CMD ["--version"]