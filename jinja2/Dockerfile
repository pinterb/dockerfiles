FROM pinterb/base:alpine

MAINTAINER Brad Pinter <brad.pinter@gmail.com>

RUN apk add --update \
  python-dev \
  python \
  sshpass \
  openssh-client \
  sudo \
  py-pip && \
  pip install --upgrade pip && \
  pip install \
  PyYAML \
  Jinja2 \
  httplib2 \
  urllib3 \
  simplejson

## Cleanup
RUN apk del \
  python-dev \
  make && \
  rm -rf /var/cache/apk/*

RUN addgroup dev && \
  adduser -G dev dev -D -h /home/dev && \
  mkdir -p /home/dev/bin /home/dev/lib /home/dev/include /home/dev/.ssh && \
  chown -R dev:dev /home/dev && chown -R dev:dev /home/dev/.ssh && \
  ssh-keygen -t rsa -N '' -f /home/dev/.ssh/dummy_rsa && \
  sed -ri 's/(wheel:x:10:root)/\1,dev/' /etc/group && \
  sed -ri 's/# %wheel ALL=\(ALL\) NOPASSWD: ALL/%wheel ALL=\(ALL\) NOPASSWD: ALL/' /etc/sudoers

ENV PATH /home/dev/bin:$PATH
  
# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
RUN mkdir /data/ && \
 touch /data/.extra && \
 chown -R dev:dev /data

## Expose some volumes
VOLUME ["/data", "/home/dev/.ssh"]

ENV HOME /home/dev
ENV TEMPLATES_DIR /data
ENV TEMPLATE my.tmpl

COPY render.py $HOME/bin/render.py
RUN chown -R dev:dev /home/dev/bin && chmod 700 /home/dev/bin/render.py
USER dev
WORKDIR /data

ENTRYPOINT ["/home/dev/bin/render.py"]
