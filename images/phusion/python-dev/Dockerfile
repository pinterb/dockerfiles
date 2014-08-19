# pinterb/phusion-python-dev
#
# VERSION     0.0.9
#
# CREATED ON  2014-08-16T16:35:49CDT

FROM pinterb/phusion-python:0.0.9

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive


### install python dev packages
RUN apt-get install -y \
 pylint \
 python-coverage python3-coverage \
 pep8 python3-pep8


## create a virtualenv environment for app user to use.
RUN mkdir -p /home/app/.virtualenvs
RUN chown app:app /home/app/.virtualenvs

### install virtualenv packages
RUN apt-get install -y \
 python-virtualenv virtualenvwrapper


### make debian interactive...
RUN env --unset=DEBIAN_FRONTEND

### define default command.
CMD ["/sbin/my_init"]
