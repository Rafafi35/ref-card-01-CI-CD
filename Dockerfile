FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /workspace

# Zuerst die Maven-Metadaten für besseres Docker-Cache-Verhalten kopieren.
COPY pom.xml .
RUN mvn -q dependency:go-offline

# Danach den Quellcode kopieren und das ausführbare JAR bauen.
COPY src ./src
RUN mvn -q -DskipTests package

FROM eclipse-temurin:21-jre-jammy AS runtime
WORKDIR /app

COPY --from=build /workspace/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

