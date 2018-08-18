FROM openjdk:8-jdk-alpine

COPY build.id .

WORKDIR /

CMD java -version
