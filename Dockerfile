FROM debian:buster

RUN LC_ALL=C \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y \
        ca-certificates \
        git \
        python3 \
        python3-flask-restful \
        python3-tornado \
        python3-requests \
        && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/*

ADD ./ /opt/app/
WORKDIR /opt/app

EXPOSE 8080

CMD ["python3", "server.py"]
