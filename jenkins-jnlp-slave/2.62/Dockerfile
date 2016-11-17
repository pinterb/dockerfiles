FROM jenkinsci/jnlp-slave

MAINTAINER Brad Pinter <brad.pinter@gmail.com>

LABEL vendor="Jenkins" \
      org.jenkins-ci.jenkinsci.version="2.62" \
      org.jenkins-ci.jenkinsci.release-date="2016-08-15"

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV HELM_VERSION 2.0.0
ENV PATH /opt/google-cloud-sdk/bin:$PATH

USER root

RUN apt-get update -y
RUN apt-get install -y jq make
RUN curl https://sdk.cloud.google.com | bash && mv google-cloud-sdk /opt
RUN gcloud components install kubectl

WORKDIR /tmp

RUN curl -Lo helm.${HELM_VERSION}.tar.gz "http://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
RUN gunzip /tmp/helm.${HELM_VERSION}.tar.gz && \
  tar -xvf /tmp/helm.2.0.0.tar && \
  cp /tmp/linux-amd64/helm /usr/local/bin/ && \
  rm /tmp/helm.2.0.0.tar && \
  rm -rf /tmp/linux-amd64/

WORKDIR /home/jenkins
