###-->ZZZ_IMAGE<--###
#
# VERSION      ###-->ZZZ_VERSION<--###

FROM ###-->ZZZ_BASE_IMAGE<--###

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

###-->ZZZ_ENABLE_REPOS<--###
###-->ZZZ_PREPARE<--###
###-->ZZZ_PACKAGES<--###
###-->ZZZ_CONFIGURE<--###
###-->ZZZ_FINALIZE<--###

### locale
RUN locale-gen en_US.UTF-8 && \
 dpkg-reconfigure locales && \
 update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8

###-->ZZZ_CMD_ENTRYPOINT<--###
