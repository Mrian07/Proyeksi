FROM node:14.17
MAINTAINER operations@proyeksiapp.com

ARG DEV_UID=1000
ARG DEV_GID=1001

ENV USER=node

RUN apt-get update && apt-get install -y chromium

RUN npm i -g npm

RUN groupadd $USER || true
RUN groupmod -g $DEV_GID $USER || true
RUN usermod -u $DEV_UID -d /home/dev $USER || true

EXPOSE 4200

RUN mkdir -p /home/dev/proyeksiapp/public/assets/frontend
RUN chown $USER:$USER -R /home/dev

VOLUME ["/home/dev/proyeksiapp", "/home/dev/proyeksiapp/public/assets/frontend"]

WORKDIR /home/dev/proyeksiapp/frontend

USER $USER
