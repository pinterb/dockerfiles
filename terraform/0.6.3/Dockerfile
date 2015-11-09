FROM pinterb/base:alpine

MAINTAINER Brad Pinter <brad.pinter@gmail.com>

ENV TERRAFORM_VERSION 0.6.3

RUN apk update && \
    apk add --update wget ca-certificates unzip && \
    apk add --update bash openssh-client sudo && \
    wget -q "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" && \
    apk add --allow-untrusted glibc-2.21-r2.apk && \
    wget -q -O /terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip /terraform.zip -d /bin && \
    apk del --purge wget ca-certificates unzip && \
    rm -rf /var/cache/apk/* glibc-2.21-r2.apk /terraform.zip

ENV PATH /terraform:$PATH

RUN addgroup dev && \
    adduser -G dev dev -D -h /home/dev && \
    mkdir -p /home/dev/bin /home/dev/lib /home/dev/include /home/dev/.ssh && \
    sed -ri 's/(wheel:x:10:root)/\1,dev/' /etc/group && \
    sed -ri 's/# %wheel ALL=\(ALL\) NOPASSWD: ALL/%wheel ALL=\(ALL\) NOPASSWD: ALL/' /etc/sudoers

ENV PATH /home/dev/bin:$PATH

RUN ssh-keygen -t rsa -N '' -f /home/dev/.ssh/dummy_rsa && \
    chown -R dev:dev /home/dev/.ssh

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
RUN mkdir /data/ /ops/ /state/
RUN touch /data/.extra /ops/.extra /state/.extra
RUN chown -R dev:dev /data
RUN chown -R dev:dev /ops
RUN chown -R dev:dev /state

## Expose some volumes
VOLUME ["/data", "/ops", "/state", "/home/dev/.ssh"]

ENV HOME /home/dev
USER dev
WORKDIR /data

ENTRYPOINT ["/bin/terraform"]
CMD ["--help"]
