# phusion-base
#
# VERSION      0.0.3

# Pull Phusion's image
FROM phusion/passenger-customizable:0.9.10

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
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


### Run image-specific install script
RUN mkdir -p /build
ADD . /build
RUN /build/install.sh


### Set timezone
ENV TIMEZONE UTC
ONBUILD RUN echo ${TIMEZONE} > /etc/timezone && \
 cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
 dpkg-reconfigure --frontend noninteractive tzdata


### locale
RUN locale-gen en_US.UTF-8 && \
 dpkg-reconfigure locales && \
 update-locale LANG=en_US.UTF-8


ENV LC_ALL en_US.UTF-8

### Define default command.
CMD ["/sbin/my_init"]
