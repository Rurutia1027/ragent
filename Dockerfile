# Multi-module Maven project: framework, infra-ai, mcp-server (libs) + bootstrap (runnable app).
# We build only bootstrap and its upstream modules (-am), producing a single runnable JAR (monolithic deploy).
FROM maven:3.9-eclipse-temurin-17-alpine AS builder
WORKDIR /build

# Copy root POM and all module POMs so the refactor is defined
COPY pom.xml .
COPY framework/pom.xml framework/
COPY infra-ai/pom.xml infra-ai/
COPY mcp-server/pom.xml mcp-server/
COPY bootstrap/pom.xml bootstrap/

# Resolve dependencies only for bootstrap and its dependnecies (framework, infra-ai)
RUN mvn dependency:go-offline -pl bootstrap -am -B -q || true

# Copy full source and build only the bootstrap app (and its module deps)
COPY . .
RUN mvn package -pl bootstrap -am -DskipTests -B -q

# Runtime stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

RUN apk add --no-cache curl

# Non-root user
RUN adduser -D -u 1000 ragent
USER ragent

COPY --from=builder /build/bootstrap/target/bootstrap-*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]