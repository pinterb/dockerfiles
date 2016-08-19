FROM openjdk:8-jdk-alpine

MAINTAINER Brad Pinter "brad.pinter@gmail.com"

# This is the release of swagger-codegen to pull in.
LABEL vendor="Swagger" \
      io.swagger.swagger-codegen.version="2.2.0" \
      io.swagger.swagger-codegen.release-date="2016-07-17"

# Our dev user set-up
ENV USER_GID 1000
ENV USER_UID 1000

RUN apk --update add --no-cache bash sudo openssh-client && \
  addgroup -g $USER_GID dev && \
  adduser -h /home/dev -u $USER_UID -D -G dev -s /bin/bash dev && \
  mkdir -p /home/dev/bin /home/dev/.ssh && \
  sed -ri 's/(wheel:x:10:root)/\1,dev/' /etc/group && \
  sed -ri 's/# %wheel ALL=\(ALL\) NOPASSWD: ALL/%wheel ALL=\(ALL\) NOPASSWD: ALL/' /etc/sudoers

RUN ssh-keygen -t rsa -N '' -f /home/dev/.ssh/dummy_rsa && \
  chown -R dev:dev /home/dev/.ssh /home/dev/bin

ENV PATH /home/dev/bin:$PATH

# Packages for using swagger-codegen
RUN apk add --no-cache ca-certificates wget git && \
  rm -rf /var/cache/apk/*

ENV MVN_VERSION 3.3.9
RUN wget \
http://apache.mirrors.tds.net/maven/maven-3/3.3.9/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz
RUN tar -zxvf apache-maven-${MVN_VERSION}-bin.tar.gz
RUN rm apache-maven-${MVN_VERSION}-bin.tar.gz
RUN mv apache-maven-${MVN_VERSION} /usr/lib/mvn


# Download swagger-codegen 
ENV SWAGGER_CODEGEN_TAG "2.2.0"
ENV SWAGGER_CODEGEN_GIT_REPO http://github.com/swagger-api/swagger-codegen.git

RUN mkdir -p /opt && \
 git clone --branch v$SWAGGER_CODEGEN_TAG --depth 1 $SWAGGER_CODEGEN_GIT_REPO \
 /opt/swagger-codegen

# Build swagger-codegen
WORKDIR /opt/swagger-codegen
RUN /usr/lib/mvn/bin/mvn clean package

RUN mv /opt/swagger-codegen/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar /opt/
RUN mv /opt/swagger-codegen/modules/swagger-codegen/target/swagger-codegen-2.2.0.jar /opt/
RUN mv /opt/swagger-codegen/modules/swagger-generator/target/swagger-generator-2.2.0.war /opt/
WORKDIR /opt
RUN rm -rf /opt/swagger-codegen/


RUN apk del --purge wget ca-certificates && \
  rm -rf /var/cache/apk/*

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
RUN mkdir /data/ /output/ /state/ /config/
RUN touch /data/.extra /output/.extra /state/.extra /config/.extra
RUN chown -R dev:dev /data && \
    chown -R dev:dev /output && \
    chown -R dev:dev /state && \
    chown -R dev:dev /config

VOLUME ["/data", "/output", "/state", "/home/dev/.ssh"]
EXPOSE 8080

ENV HOME /home/dev
USER dev
WORKDIR /data

ENTRYPOINT ["java", "-jar", "/opt/swagger-codegen-cli.jar"]
CMD ["langs"]

#CMD ["/bin/bash"]
