
### apt update, upgrade and install base packages
RUN apt-get update -q && \
 apt-get -y upgrade && \
 apt-get install -y \
 build-essential \
 software-properties-common \
 language-pack-en \
 socat \
 python-software-properties python-setuptools python-pip python-all-dev \
 byobu curl htop unzip vim wget rsync tree less \
 locales daemontools cron \
 git mercurial bzr subversion
