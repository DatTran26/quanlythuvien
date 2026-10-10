FROM eclipse-temurin:21-jdk AS build
WORKDIR /src
COPY . .
RUN chmod +x mvnw && ./mvnw -q -DskipTests package

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /src/target/library-api.jar app.jar
ENV JAVA_TOOL_OPTIONS="-Xmx512m"
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
