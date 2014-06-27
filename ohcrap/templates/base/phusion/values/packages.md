## Apt update, upgrade and install required packages
RUN apt-get update -q && \
 apt-get -y upgrade && \
 apt-get install -y \
 build-essential \
 software-properties-common \
 language-pack-en \
 socat \
 ntp \
 byobu curl htop unzip vim wget rsync tree less \
 locales daemontools cron \
 git mercurial bzr subversion
