# Stage 1: Build the application
FROM maven:3.8.5-openjdk-8-slim AS build

WORKDIR /app

# Copy only pom.xml first
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy the source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:8-jre   # <-- FIXED (no alpine issue)

ENV PROJECT_HOME=/opt/app

WORKDIR $PROJECT_HOME

# Copy the JAR file from stage 1
COPY --from=build /app/target/spring-boot-mongo-1.0.jar spring-boot-mongo.jar

EXPOSE 8080

CMD ["java", "-jar", "spring-boot-mongo.jar"]
