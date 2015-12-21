FROM golang:1.4
MAINTAINER Lukas Martinelli <me@lukasmartinelli.ch>

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        postgresql-client \
 && rm -rf /var/lib/apt/lists/*

RUN go get github.com/lukasmartinelli/pgfutter

COPY . /usr/src/app/
WORKDIR /usr/src/app

VOLUME /data
CMD ["./import.sh"]
