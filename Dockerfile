# Multi-module Maven project: framework, infra-ai, mcp-server (libs) + bootstrap (runnable app).
# We build only bootstrap and its upstream modules (-am), producing a single runnable JAR (monolithic deploy).
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /build

# Copy root POM and all module POMs so the reactor is defined
COPY pom.xml .
COPY framework/pom.xml framework/
COPY infra-ai/pom.xml infra-ai/
COPY mcp-server/pom.xml mcp-server/
COPY bootstrap/pom.xml bootstrap/

# Resolve dependencies only for bootstrap and its dependencies (framework, infra-ai)
RUN ./mvnw -q -DskipTests -DskipITs -pl bootstrap -am dependency:go-offline || true

# Copy full source and build only the bootstrap app (and its module deps)
COPY . .
RUN ./mvnw -q -DskipTests -DskipITs -pl bootstrap -am package

# Runtime stage
FROM eclipse-temurin:17-jdk
WORKDIR /app

COPY --from=builder /build/bootstrap/target/bootstrap-*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]