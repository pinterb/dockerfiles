# ubuntu-base
#
# VERSION      0.0.1

# Pull base image.
FROM ubuntu:14.04

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Select your closest mirror from...
# US West Coast (N. California):        us-west-1.ec2.archive
# US West Coast (Oregon):               us-west-2.ec2.archive
# US East Coast (N. Virginia):          us-east-1.ec2.archive
# South America (São Paulo, Brazil):    sa-east-1.ec2.archive
# Western Europe (Dublin, Ireland):     eu-west-1.ec2.archive
# NorthEast Asia (Tokyo):               ap-northeast-1.ec2.archive
# SouthEast Asia (Singapore):           ap-southeast-1.ec2.archive
# Australia (Sydney):                   ap-southeast-2.ec2.archive
# ... and assign UBUNTU_MIRROR below with your selection
ENV UBUNTU_MIRROR us-east-1.ec2.archive
ONBUILD RUN sed "s@archive@${UBUNTU_MIRROR}@" -i /etc/apt/sources.list

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update -q && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y language-pack-en python-setuptools && \
  apt-get install -y byobu curl htop man unzip vim wget rsync tree less && \
  apt-get install -y locales ntp daemontools cron && \
  apt-get install -y git mercurial bzr subversion && \
  apt-get install -y openssh-server && \
  apt-get install -y supervisor && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  env --unset=DEBIAN_FRONTEND

# SSH login fix. Otherwise user is kicked off after login
# And...have supervisord run in nodaemon mode
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
 mkdir -p /var/run/sshd && \
 echo 'root:root' | chpasswd

EXPOSE 22

# Set up supervisord to run in nodaemon mode and also run ntpd and sshd
RUN sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf &&\
 echo "" >> /etc/supervisor/supervisord.conf && \
 echo "[program:sshd]" >> /etc/supervisor/supervisord.conf && \
 echo "command=/usr/sbin/sshd -D" >> /etc/supervisor/supervisord.conf && \
 echo "stdout_logfile=/var/log/supervisor/%(program_name)s.log" >> /etc/supervisor/supervisord.conf && \
 echo "stderr_logfile=/var/log/supervisor/%(program_name)s.log" >> /etc/supervisor/supervisord.conf && \
 echo "autorestart=true" >> /etc/supervisor/supervisord.conf && \
 echo "" >> /etc/supervisor/supervisord.conf && \
 echo "[program:ntpd]" >> /etc/supervisor/supervisord.conf && \
 echo "command=/usr/sbin/ntpd -u ntp -n -g" >> /etc/supervisor/supervisord.conf && \
 echo "autorestart=true" >> /etc/supervisor/supervisord.conf

# Set timezone
# The city selections might seem arbitrary, but they incorporate daylight savings
# time automatically based on time zone and are better then manually picking
# using the 'Etc/GMT+0' files.
ENV TIMEZONE US/Central
ONBUILD RUN echo ${TIMEZONE} > /etc/timezone && \
  cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
  dpkg-reconfigure --frontend noninteractive tzdata

RUN echo "ntpdate ntp.ubuntu.com" > /etc/cron.daily/ntpdate && \
 chmod 755 /etc/cron.daily/ntpdate && \
 rm -f /etc/cron.daily/standard

# locale
RUN locale-gen en_US.UTF-8 && \
 dpkg-reconfigure locales && \
 update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8

# Define mountable directories.
VOLUME ["/data", "/etc/supervisor/conf.d"]

# Define default command.
##CMD ["/bin/bash"]

###ENTRYPOINT \
###  supervisord \
###  --configuration=/etc/supervisor/supervisord.conf

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

