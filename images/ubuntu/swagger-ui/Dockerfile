FROM pinterb/json:0.0.11

ENV DEBIAN_FRONTEND noninteractive

# Let's start with some basic stuff.
RUN set -x && \
    apt-get install --no-install-recommends -y -q \
    nginx

RUN service nginx stop

ADD swagger /etc/nginx/sites-available/
RUN cd /etc/nginx/sites-enabled/ && ln -s ../sites-available/swagger
RUN rm -f /etc/nginx/sites-enabled/default

RUN echo 'daemon off;' >> /etc/nginx/nginx.conf

ADD run.sh /usr/local/bin/
ADD swagger-ui-templates /swagger-ui-templates
VOLUME /swagger-data

ENV SWAGGER_UI_VERSION 2.1.0-alpha.6
RUN mkdir /swagger
ADD https://github.com/pinterb/swagger-ui/archive/v$SWAGGER_UI_VERSION.zip /swagger/
WORKDIR /swagger
RUN unzip v$SWAGGER_UI_VERSION.zip
RUN mv swagger-ui-$SWAGGER_UI_VERSION/dist/* .
RUN rm -rf v$SWAGGER_UI_VERSION.zip \
    rm -rf swagger-ui-$SWAGGER_UI_VERSION

### Make Debian interactive...
RUN env --unset=DEBIAN_FRONTEND

EXPOSE 80

CMD run.sh
