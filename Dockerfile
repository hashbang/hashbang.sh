FROM debian:jessie

RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list.d/nginx.list
RUN apt-key adv --fetch-keys "http://nginx.org/keys/nginx_signing.key"

RUN apt-get update -y --fix-missing
RUN apt-get upgrade -y --fix-missing

RUN apt-get install -y --force-yes \
  nginx \
  ca-certificates \

VOLUME /opt/app/certs

EXPOSE 80
EXPOSE 443

WORKDIR /app

RUN rm -rf /etc/nginx/conf.d/*
ADD nginx.conf /etc/nginx/nginx.conf

ADD index.html /opt/app/

CMD ["nginx"]
