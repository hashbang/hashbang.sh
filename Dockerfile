FROM debian:buster

RUN LC_ALL=C \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y \
        ca-certificates \
        git \
        python3 \
	python3-pip && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/* && \
    pip3 install pipenv

ADD ./ /opt/app/
WORKDIR /opt/app

RUN pipenv install

EXPOSE 8080

CMD ["pipenv", "run", "python3", "server.py"]
