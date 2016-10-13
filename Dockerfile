FROM debian:stretch

RUN LC_ALL=C \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y \
        git \
        python-backports.ssl-match-hostname \
        python-certifi \
        python-flask-restful \
        python-ldap \
        python-tornado \
        python-pip \
        && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/*

ADD ./ /opt/app/
WORKDIR /opt/app
RUN pip install -r requirements.txt

EXPOSE 4443

CMD ["python2.7", "server.py"]
