# pinterb/ubuntu-python-falcon
#
# VERSION     0.0.13
#
# CREATED ON  2015-02-19T17:01:09UTC

FROM pinterb/ubuntu-python:0.0.13

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

## Install Python's Falcon framework along with some testing support
WORKDIR /build
RUN echo 'sqlalchemy==0.9.6' > py-app-requirements.txt && \
 echo 'pytz==2014.4' >> py-app-requirements.txt && \
 echo 'uwsgi==2.0.6' >> py-app-requirements.txt && \
 echo 'mock==1.0.1' >> py-app-requirements.txt && \
 echo 'pytest==2.5.2' >> py-app-requirements.txt && \
 echo 'coverage==3.7.1' >> py-app-requirements.txt && \
 echo 'pep8==1.5.7' >> py-app-requirements.txt && \
 echo 'python-dateutil==2.2' >> py-app-requirements.txt && \
 echo 'nose==1.3.3' >> py-app-requirements.txt && \
 echo 'tox==1.7.1' >> py-app-requirements.txt && \
 echo 'greenlet==0.4.2' >> py-app-requirements.txt && \
 echo 'gevent==1.0.1' >> py-app-requirements.txt && \
 echo 'cython==0.20.2' >> py-app-requirements.txt && \
 echo 'falcon==0.1.8' >> py-app-requirements.txt && \
 echo 'behave==1.2.4' >> py-app-requirements.txt && \
 echo 'pyhamcrest==1.8.0' >> py-app-requirements.txt && \
 echo 'testtools==0.9.35' >> py-app-requirements.txt && \
 echo 'six==1.7.3' >> py-app-requirements.txt && \
 echo 'requests==2.3.0' >> py-app-requirements.txt && \
 pip install -r /build/py-app-requirements.txt

### make debian interactive...
RUN env --unset=DEBIAN_FRONTEND

### define default command.
CMD ["/bin/bash"]
