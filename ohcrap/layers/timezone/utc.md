
### set timezone
ENV TIMEZONE UTC
ONBUILD RUN echo ${TIMEZONE} > /etc/timezone && \
 cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
 dpkg-reconfigure --frontend noninteractive tzdata
