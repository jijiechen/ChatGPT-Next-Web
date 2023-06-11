FROM node:18-alpine AS base

FROM base AS deps

RUN apk add --no-cache libc6-compat

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn config set registry 'https://registry.npmmirror.com/'
RUN yarn install


#=======================================
FROM base AS builder

RUN apk update && apk add --no-cache git

ENV BUILD_MODE=export

WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN yarn export


#=======================================
FROM nginx:1.25.0-alpine
WORKDIR /usr/share/nginx/html

COPY --from=builder /app/out ./

RUN mv index.html chat.html
COPY --from=builder /app/tcb_auth.html ./index.html
COPY --from=builder /app/MP_verify_jVn5jfIjPg6sKUqo.txt ./