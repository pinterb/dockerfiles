# ###-->ZZZ_IMAGE<--###
#
# VERSION     ###-->ZZZ_VERSION<--###
#
# CREATED ON  ###-->ZZZ_DATE<--###

FROM ###-->ZZZ_BASE_IMAGE<--###

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive


### install python stuff
RUN apt-get install -y \
 python-setuptools \
 python-dev \
 python-pip \
 pylint \
 python3 python3-setuptools python3-pip python3-all-dev

### install virtualenv
RUN pip install --upgrade virtualenv

### install autoremove
RUN pip install pip-autoremove

### make debian interactive...
RUN env --unset=DEBIAN_FRONTEND

### define default command.
CMD ["/bin/bash"]
