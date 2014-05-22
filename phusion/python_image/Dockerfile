# phusion-python
#
# VERSION      0.0.2

FROM pinterb/phusion-base:0.0.2

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

### enable repos and update
RUN apt-get update -q


### prepare system
## Create a virtualenv environment for app user to use.
RUN mkdir -p /home/app/.virtualenvs
RUN chown app:app /home/app/.virtualenvs


### install packages
RUN apt-get install -y --no-install-recommends python python2.7 python3 \
 python-pip python3-pip \
 python-virtualenv virtualenvwrapper python-tox pbundler \
 python-sphinx python3-sphinx python-docutils python3-docutils \
 python-sphinxcontrib.issuetracker python-sphinxcontrib-httpdomain python-sphinxcontrib.blockdiag python-sphinxcontrib.nwdiag \
 python-sphinxcontrib.seqdiag python-sphinxcontrib.spelling python-sphinxcontrib-docbookrestapi


### configure
RUN mkdir -p /build
ADD . /build

# Configure python's virtualenv
RUN cp /build/config/python.sh /etc/profile.d/python.sh


### finalize build
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm -rf /build/config/*
RUN rm -rf /build/test/*
RUN rm -rf /build/test
RUN rm -f /build/{Dockerfile,README.md,buildconfig,insecure_key*}


### run our init
CMD ["/sbin/my_init"]
