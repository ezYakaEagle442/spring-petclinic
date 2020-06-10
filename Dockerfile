FROM mcr.microsoft.com/java/maven:11u7-zulu-debian10
VOLUME /tmp
ADD target/ app.jar
RUN touch /app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app.jar"]