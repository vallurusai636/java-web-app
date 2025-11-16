# Multi-stage Dockerfile
FROM maven:3.9.2-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests clean package

FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY --from=builder /app/target/java-web-app-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
