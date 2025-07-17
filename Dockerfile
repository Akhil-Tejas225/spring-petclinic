FROM maven:3.9.10-eclipse-temurin-17-alpine AS builder
LABEL "stage"="build"
LABEL "author"="Akhil"
RUN mkdir /spc
WORKDIR /spc
COPY ./spring-petclinic .
RUN mvn clean package


FROM  amazoncorretto:17.0.15-al2023-headless
RUN mkdir petclinic
USER nobody
WORKDIR /petclinic
COPY --from=builder --chown=nobody:nobody spc/target/*.jar .
EXPOSE 8080
CMD ["java", "-jar", "spring-petclinic-3.4.0-SNAPSHOT.jar"]
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "ping","-c", "1", "https://localhost:8080" ]