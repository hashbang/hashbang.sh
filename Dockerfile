FROM debian:wheezy

RUN LC_ALL=C \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y \
        git \
        python-dev \
        python-pip \
        build-essential \
        libldap2-dev \
        libsasl2-dev \
        libssl-dev && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/*

ADD ./ /opt/app/
WORKDIR /opt/app
RUN pip install -r requirements.txt

EXPOSE 4443

CMD ["python2.7", "-m", "http.server", "80"]
