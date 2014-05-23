# phusion-ansible
#
# VERSION      0.0.2

FROM pinterb/phusion-python:0.0.2

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
RUN apt-get install -y --no-install-recommends libyaml-dev python-yaml python3-yaml \
 python-jinja2 python3-jinja2 python-jinja2-doc


### configure
# install ansible
RUN pip install ansible
RUN ansible --version


### finalize build
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


### run our init
CMD ["/sbin/my_init"]
