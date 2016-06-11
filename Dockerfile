FROM debian:jessie

# Install Nginx
RUN apt-get install -y --force-yes nginx
RUN rm -rf /etc/nginx/conf.d/*

# Location Nginx expects certs to be in
# Must be named server.key and server.crt
VOLUME /opt/app/certs

WORKDIR /opt/app

EXPOSE 80
EXPOSE 443

ADD nginx.conf /etc/nginx/nginx.conf

ADD static/ /opt/app/

CMD ["nginx"] 
