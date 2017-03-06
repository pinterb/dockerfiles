FROM jenkins:2.32.3

MAINTAINER Brad Pinter <brad.pinter@gmail.com>

# Metadata params
ARG VCS_URL
ARG VCS_REF
ARG BUILD_DATE
ARG VERSION

# Metadata
LABEL org.label-schema.name="Jenkins Master" \
      org.label-schema.description="A Jenkins master a couple of extra plugins." \
      org.label-schema.vendor="CDW" \
      org.label-schema.url="https://cdw.com" \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$VERSION \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.schema-version="1.0.0-rc.1"

USER root
RUN apt-get install -y wget git
RUN wget --no-verbose -O /tmp/apache-maven-3.2.2.tar.gz http://archive.apache.org/dist/maven/maven-3/3.2.2/binaries/apache-maven-3.2.2-bin.tar.gz
RUN echo "87e5cc81bc4ab9b83986b3e77e6b3095 /tmp/apache-maven-3.2.2.tar.gz" | md5sum -c
RUN tar xzf /tmp/apache-maven-3.2.2.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.2.2 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.2.2.tar.gz
ENV MAVEN_HOME /opt/maven

USER jenkins
RUN /usr/local/bin/install-plugins.sh \
  kubernetes:0.11 \
  credentials:2.1.13 \
  credentials-binding:1.10 \
  google-oauth-plugin:0.4 \
  aws-credentials:1.19 \
  aws-bucket-credentials:0.1.1 \
  aws-lambda:0.5.8 \
  aws-sqs:1.004 \
  snsnotify:1.13 \
  docker-workflow:1.10 \
  docker-build-step:1.39 \
  dockerhub-notification:2.2.0 \
  docker-build-publish:1.3.2 \
  aws-codebuild:0.6 \
  github-api:1.85 \
  github:1.26.1 \
  github-branch-source:2.0.3 \
  github-organization-folder:1.6 \
  github-issues:1.2.1 \
  github-pr-comment-build:1.0 \
  pipeline-githubnotify-step:1.0.1 \
  pipeline-utility-steps:1.2.2 \
  ghprb:1.35.0 \
  github-pr-coverage-status:1.4.0 \
  github-oauth:0.25 \
  pipeline-github-lib:1.0 \
  git:3.0.5 \
  terraform:1.0.9 \
  cisco-spark:1.0.5 \
  azure-vm-agents:0.4.2 \
  hyper-commons:0.1.5 \
  hyper-build-step:0.1.5 \
  hyper-slaves:0.1.7 && \
  mkdir -p /usr/share/jenkins/ref/secrets/ && \
  echo "false" > /usr/share/jenkins/ref/secrets/slave-to-master-security-kill-switch
