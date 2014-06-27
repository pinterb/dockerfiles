# Install ntp service (via runit).
RUN mkdir -p /var/log/ntpd/ && \
 mkdir -p /etc/service/ntpd/log && \
 mkdir /var/run/ntpd

RUN echo "s100000" > /var/log/ntpd/config && \
    echo "n10" >> /var/log/ntpd/config && \
    echo "N5" >> /var/log/ntpd/config && \
    echo "t86400" >> /var/log/ntpd/config && \
    echo "pNTPD_LOG" >> /var/log/ntpd/config

RUN echo "#!/bin/sh" > /etc/service/ntpd/run && \
    echo "set -e" >> /etc/service/ntpd/run && \
    echo "" >> /etc/service/ntpd/run && \
    echo "exec /usr/sbin/ntpd -u ntp -n -g 2>&1" >> /etc/service/ntpd/run && \
    chmod +x /etc/service/ntpd/run

RUN echo "#!/bin/sh" > /etc/service/ntpd/log/run && \
    echo "set -e" >> /etc/service/ntpd/log/run && \
    echo "" >> /etc/service/ntpd/log/run && \
    echo "exec svlogd -tt /var/log/ntpd/" >> /etc/service/ntpd/log/run && \
    chmod +x /etc/service/ntpd/log/run