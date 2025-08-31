# Minimal Node.js + Nginx image
# Does not automatically install application dependencies – you get a clean environment

# Stage 1: Node.js – base for development/build
FROM node:22-alpine AS base

ENV TZ=Europe/Warsaw \
    NODE_ENV=development

WORKDIR /workspace

# add nginx
RUN apk add --no-cache nginx

COPY ./docker /docker

# Remove default config and add your own SPA (React Router) config
COPY nginx-react.conf  /etc/nginx/http.d/default.conf

# Directory for application files – you will mount or copy them manually
WORKDIR /druids.me

# EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]