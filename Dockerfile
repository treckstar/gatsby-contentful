FROM node:alpine

ENV YARN_VERSION 1.22.19
ENV SHELL /bin/bash

RUN apk update
RUN apk add curl
RUN apk add build-base autoconf automake libtool pkgconfig nasm
RUN apk add python3 py3-pip make g++

RUN curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz

RUN corepack enable && corepack prepare pnpm@latest --activate
RUN pnpm setup
RUN yarn global add gatsby-cli
# RUN pnpm add -g gatsby-cli

WORKDIR /app

# COPY the package.json file, update any deps and install them
COPY package.json .
# COPY pnpm-lock.yaml .

# RUN yarn update
# RUN yarn install
RUN pnpm up --latest
RUN pnpm install
# copy the whole source folder(the dir is relative to the Dockerfile
COPY . .

CMD [ "pnpm", "run", "start" ]