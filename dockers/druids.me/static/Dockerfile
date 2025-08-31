FROM nginx:alpine

ENV TERM xterm
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV TZ=Europe/Warsaw

RUN rm -f /etc/nginx/conf.d/default.conf
COPY local.site.nginx.conf /etc/nginx/conf.d/default.conf

# Copy docker helper scripts (fix hosts)
COPY ./docker /docker

WORKDIR /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
