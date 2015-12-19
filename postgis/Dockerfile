FROM mdillon/postgis:9.4
MAINTAINER Lukas Martinelli <me@lukasmartinelli.ch>

RUN mv /docker-entrypoint-initdb.d/postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh
COPY ./initdb-schweizerdb.sh /docker-entrypoint-initdb.d/20_schweizerdb.sh
