FROM alpine:edge

ENV HOME /root

#    go-cross \
RUN apk add --update \
    go \
    go-tools \
    docker \
    make \
    bash \
    git \
    sudo && \
    rm -rf /var/cache/apk/*

RUN addgroup dev && \
    adduser -G dev dev -D -h /home/dev && \
    addgroup dev docker && \
    mkdir -p /home/dev/bin /home/dev/lib /home/dev/include /home/dev/.ssh && \
    chown -R dev:dev /home/dev && chown -R dev:dev /home/dev/.ssh && \
    sed -ri 's/(wheel:x:10:root)/\1,dev/' /etc/group && \
    sed -ri 's/# %wheel ALL=\(ALL\) NOPASSWD: ALL/%wheel ALL=\(ALL\) NOPASSWD: ALL/' /etc/sudoers

ENV PATH /home/dev/bin:$PATH

ADD build_environment.sh /home/dev/bin/
ADD go.sh /home/dev/bin/
RUN chown -R dev:dev /home/dev/bin

RUN mkdir -p /go/src/x/y/z
RUN chown -R dev:dev /go

VOLUME ["/src"]
WORKDIR /src

ENV HOME /home/dev
USER dev

#ENTRYPOINT ["sh", "/home/dev/bin/go.sh"]
#ENTRYPOINT ["/bin/bash", "/home/dev/bin/go.sh"]
CMD ["/bin/bash"]
