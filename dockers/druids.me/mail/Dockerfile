FROM ubuntu:22.04

ENV TERM xterm
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV TZ=Europe/Warsaw

RUN apt-get update -y
RUN apt-get install -y apt-utils
RUN apt-get upgrade -y

RUN apt-get install -y apt-utils

RUN apt-get install -y software-properties-common curl wget locales

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y ruby-dev rubygems build-essential bison
RUN gem install net-imap -v 0.3.7

RUN gem install sqlite3 -v 1.7.1
RUN gem install mailcatcher

COPY ./docker /docker

ENTRYPOINT ["mailcatcher", "--ip", "0.0.0.0", "--http-port", "80", "-f"]
# ENTRYPOINT ["tail", "-f", "/dev/null"] # Use this for resolution of issues