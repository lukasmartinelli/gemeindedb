FROM node:0.10
MAINTAINER Lukas Martinelli <me@lukasmartinelli.ch>

RUN mkdir -p /usr/src/app
RUN git clone https://github.com/mapbox/mapbox-studio-classic.git /usr/src/app
WORKDIR /usr/src/app

RUN npm install

VOLUME /projects
EXPOSE 3000
CMD ["npm", "start"]

