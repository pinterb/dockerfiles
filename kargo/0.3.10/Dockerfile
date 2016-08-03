FROM pinterb/base:alpine

MAINTAINER Brad Pinter <brad.pinter@gmail.com>

RUN apk add --update \
  build-base \
  gcc \
  abuild \
  binutils \
  libffi-dev \
  openssl-dev \
  perl \
  git \
  python-dev \
  python \
  py-setuptools \
  py-yaml \
  sshpass \
  openssh-client \
  sudo \
  py-pip && \
  pip install --upgrade pip && \
  pip install \
  python-keyczar \
  Jinja2 \
  httplib2 \
  urllib3 \
  simplejson \
  python-consul \
  docker-py==1.9.0rc2 \
  kargo && \
  pip uninstall -y cryptography 

# Install Ansible
ENV ANSIBLE_TAG "2.1.0.0-1"
ENV ANSIBLE_GIT_REPO http://github.com/ansible/ansible.git

RUN mkdir -p /etc/ansible/roles /opt && \
  touch /etc/ansible/hosts.NOT.USED

RUN git clone --branch v$ANSIBLE_TAG --depth 1 $ANSIBLE_GIT_REPO /opt/ansible
WORKDIR /opt/ansible
RUN git submodule update --init --recursive

ENV PATH /opt/ansible/bin:/bin:/usr/bin:/sbin:/usr/sbin
ENV PYTHONPATH /opt/ansible/lib
ENV ANSIBLE_LIBRARY /opt/ansible/lib/ansible/modules/core:/opt/ansible/lib/ansible/modules/extras

## Cleanup
#  perl \
RUN apk del \
  python-dev \
  make \
  build-base \
  g++ \
  gcc \
  abuild \
  binutils \
  libffi-dev \
  openssl-dev && \
  rm -rf /var/cache/apk/*

RUN addgroup dev && \
  adduser -G dev dev -D -h /home/dev && \
  mkdir -p /home/dev/bin /home/dev/lib /home/dev/include /home/dev/.ssh && \
  chown -R dev:dev /home/dev && chown -R dev:dev /home/dev/.ssh && \
  ssh-keygen -t rsa -N '' -f /home/dev/.ssh/dummy_rsa && \
  sed -ri 's/(wheel:x:10:root)/\1,dev/' /etc/group && \
  sed -ri 's/# %wheel ALL=\(ALL\) NOPASSWD: ALL/%wheel ALL=\(ALL\) NOPASSWD: ALL/' /etc/sudoers

ENV PATH /opt/ansible/bin:/home/dev/bin:$PATH
ENV PATH /home/dev/bin:$PATH
  
# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
RUN mkdir /data/ /ops/ /state/ /ansible/ && \
 touch /data/.extra /ops/.extra /state/.extra /ansible/.extra && \
 chown -R dev:dev /data && \
 chown -R dev:dev /ops && \
 chown -R dev:dev /state && \
 chown -R dev:dev /ansible

## Expose some volumes
VOLUME ["/data", "/ops", "/state", "/ansible", "/home/dev/.ssh"]

ENV KARGO_GIT_REPO https://github.com/kubespray/kargo.git 
ENV HOME /home/dev
USER dev
#COPY ansible.cfg $HOME/.ansible.cfg
RUN git clone $KARGO_GIT_REPO /home/dev/kargo && \
  touch /home/dev/kargo/kargo.log
WORKDIR /home/dev/kargo


ENTRYPOINT ["kargo"]
CMD ["--version"]

#CMD ["/bin/bash"]

