

## create a virtualenv environment for app user to use.
RUN mkdir -p /home/app/.virtualenvs
RUN chown app:app /home/app/.virtualenvs

### install virtualenv packages
RUN apt-get install -y \
 python-virtualenv virtualenvwrapper
