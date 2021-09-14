FROM node:14-alpine

ARG GITLAB_ACCESS_TOKEN

WORKDIR /app

COPY package.json yarn.lock /app
COPY .npmrc /app/.npmrc

RUN yarn install && \
    rm -rf /tmp/* /var/tmp/*

COPY ./docker-utils/entrypoint/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

COPY . /app

RUN yarn build

EXPOSE 3000

USER node

ENV TYPEORM_MIGRATION=ENABLE
ENV NPM_INSTALL=DISABLE
ENV GITLAB_ACCESS_TOKEN=${GITLAB_ACCESS_TOKEN}
CMD yarn start:prod
