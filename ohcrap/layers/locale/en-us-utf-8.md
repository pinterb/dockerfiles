
### locale
RUN locale-gen en_US.UTF-8 && \
 dpkg-reconfigure locales && \
 update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
