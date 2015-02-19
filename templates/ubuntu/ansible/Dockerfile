FROM ###-->ZZZ_BASE_IMAGE<--###

ENV DEBIAN_FRONTEND noninteractive

# Let's start with some basic stuff.
RUN set -x && \
    apt-get install --no-install-recommends -y -q \
    python-yaml \
    python-jinja2 \
    python-httplib2 \
    python-keyczar \
    python-paramiko \
    python-pkg-resources

RUN locale-gen en_US.UTF-8 && \
    echo "en_US.UTF-8" >> /etc/environment && \
    dpkg-reconfigure locales


### Install Ansible 
ENV ANSIBLE_VERSION ###-->ZZZ_ANSIBLE_VERSION<--###

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
