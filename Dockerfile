# Multi-Stage pipeline: docker build --no-cache -t "petclinic-zulu11" -f ".\Dockerfile" .

# BUILD
FROM mcr.microsoft.com/java/maven:11u7-zulu-debian10 AS build
MAINTAINER pinpin <noname@microsoft.com>
LABEL Description="PetClinic Java Spring Boot App. built from Zulu 11"
RUN mkdir /app
WORKDIR /app
COPY . /app
RUN mvn -version
RUN mvn clean spring-javaformat:apply 
RUN mvn package -DskipTests
RUN ls /app

# Lightweight image returned as final product
FROM mcr.microsoft.com/java/jre:11u6-zulu-alpine
VOLUME /tmp
COPY --from=build /app/target/spring-petclinic-2.3.0.BUILD-SNAPSHOT.jar app.jar
RUN touch /app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app.jar"]

# On Azure Zulu JRE located at : /usr/lib/jvm/zulu-8-azure-amd64/
# to check which process runs eventually already on port 8080 :  netstat -anp | grep 8080 
# lsof -i :8080 | grep LISTEN
# ps -ef | grep PID

# Test the App
# mvn spring-boot:run