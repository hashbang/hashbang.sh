FROM debian:stretch as build

RUN LC_ALL=C \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y \
        ca-certificates \
        git \
        python-pip \
        && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/*

RUN pip install grow
ADD ./ /opt/app/
WORKDIR /opt/app

FROM nginx:latest
COPY --from=build /opt/app/dist/ /var/www/html/

