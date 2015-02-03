# pinterb/ubuntu-python
#
# VERSION     0.0.11
#
# CREATED ON  2015-02-03T16:34:04CST

FROM pinterb/ubuntu-base:0.0.11

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive


### install python3
RUN apt-get install -y \
 python3 python3-setuptools python3-pip python3-all-dev

### install autoremove
RUN pip install pip-autoremove


### make debian interactive...
RUN env --unset=DEBIAN_FRONTEND

### define default command.
CMD ["/bin/bash"]
