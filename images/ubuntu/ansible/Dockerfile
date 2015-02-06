FROM pinterb/json:0.0.10

ENV DEBIAN_FRONTEND noninteractive

# Let's start with some basic stuff.
RUN set -x && \
    apt-get install --no-install-recommends -y -q \
    locales \
    python-yaml \
    python-jinja2 \
    python-httplib2 \
    python-keyczar \
    python-paramiko \
    python-setuptools \
    python-pkg-resources \
    python-pip

RUN locale-gen en_US.UTF-8 && \
    echo "en_US.UTF-8" >> /etc/environment && \
    dpkg-reconfigure locales


### Install Ansible 
ENV ANSIBLE_VERSION 1.9 (devel 8f06ba2bc1) 

RUN mkdir /etc/ansible/ && echo '[local]\nlocalhost\n' > /etc/ansible/hosts
RUN mkdir /opt/ansible/
RUN git clone http://github.com/ansible/ansible.git /opt/ansible/ansible
WORKDIR /opt/ansible/ansible
RUN git submodule update --init
ENV PATH /opt/ansible/ansible/bin:/bin:/usr/bin:/sbin:/usr/sbin
ENV PYTHONPATH /opt/ansible/ansible/lib
ENV ANSIBLE_LIBRARY /opt/ansible/ansible/library

# Add ansible.cfg to $HOME 
ADD ansible.cfg $HOME/.ansible.cfg

### Make Debian interactive...
RUN env --unset=DEBIAN_FRONTEND

CMD ["/bin/bash"]
