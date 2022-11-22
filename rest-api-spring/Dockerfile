# BUILD
FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /app

COPY . .

RUN mvn package
VOLUME /root/.m2

#RUN
FROM openjdk:17-slim

WORKDIR /app

COPY --from=builder /app/target/*.jar .

ENV JAR_FILE=*.jar

ENTRYPOINT java -jar ${JAR_FILE}
