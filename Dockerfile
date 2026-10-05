# Stage 1: Build Java WAR package using Maven
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Runtime with Tomcat 9 & JDK 21
FROM tomcat:9.0-jdk21-openjdk-slim

# Clean default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy compiled WAR file as ROOT.war so app serves on / root URL
COPY --from=build /app/target/cityhub-1.0.0.war /usr/local/tomcat/webapps/ROOT.war

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
