# syntax=docker/dockerfile:1

FROM openjdk:18-jdk-buster

LABEL version="2.0.7"

RUN apt-get update && apt-get install -y curl unzip && \
 adduser --uid 99 --gid 100 --home /data --disabled-password minecraft

COPY launch.sh /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME /data
WORKDIR /data

CMD ["/launch.sh"]

ENV MOTD " Server Powered by Docker"
ENV LEVEL world
ENV JVM_OPTS "-Xms4096m -Xmx8192m"
