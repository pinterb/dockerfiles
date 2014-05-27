# phusion-graven
#
# VERSION      0.0.3

FROM pinterb/phusion-jvm:0.0.3

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

### install packages
# install Gradle.
RUN mkdir -p /usr/local/gradle
RUN chown root:root /usr/local/gradle
RUN wget -P /usr/local/gradle https://services.gradle.org/distributions/gradle-1.12-bin.zip
RUN cd /usr/local/gradle && unzip gradle-1.12-bin.zip && rm /usr/local/gradle/gradle-1.12-bin.zip
RUN ln -s /usr/local/gradle/gradle-1.12 /usr/local/gradle/latest

# install Maven.
RUN mkdir -p /usr/local/maven
RUN chown root:root /usr/local/maven
RUN wget -P /usr/local/maven http://apache.mirrors.tds.net/maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz
RUN cd /usr/local/maven && tar -xvzf apache-maven-3.2.1-bin.tar.gz && rm /usr/local/maven/apache-maven-3.2.1-bin.tar.gz
RUN ln -s /usr/local/maven/apache-maven-3.2.1 /usr/local/maven/latest
RUN mkdir -p /root/.m2
RUN chown root:root /root/.m2

### configure
RUN mkdir -p /build
ADD . /build

# configure /etc/provile.d/ with java info
RUN cp /build/config/gradle.sh /etc/profile.d/gradle.sh
RUN cp /build/config/maven.sh /etc/profile.d/maven.sh


### finalize build
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm -rf /build/config/*
RUN rm -rf /build/test/*
RUN rm -rf /build/test
RUN rm -f /build/{Dockerfile,README.md,buildconfig,insecure_key*}


### run our init
CMD ["/sbin/my_init"]
