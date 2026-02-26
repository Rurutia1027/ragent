#!/bin/bash
set -euo pipefail

# Usage: ./bin/build-image.sh <tag>
# Example: ./bin/build-image.sh v0.1.0

TAG=${1:-}
LATEST_TAG="latest"

if [ -z "$TAG" ]; then
  echo "Usage: $0 <tag>"
  exit 1
fi

# Docker Hub namespace (改成你的账号名，如果不是这个)
DOCKER_USER="nanachi1027"
IMAGE_NAME="ragent"

echo "Checking JAR exists (bootstrap/target/bootstrap-*.jar)..."
if ! ls bootstrap/target/bootstrap-*.jar >/dev/null 2>&1; then
  echo "ERROR: JAR not found. Please run first:"
  echo "  mvn clean package -pl bootstrap -am -DskipTests"
  exit 1
fi

echo "Building and pushing multi-arch image for ${DOCKER_USER}/${IMAGE_NAME}:${TAG} ..."

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t "${DOCKER_USER}/${IMAGE_NAME}:${TAG}" \
  -t "${DOCKER_USER}/${IMAGE_NAME}:${LATEST_TAG}" \
  --push \
  .

echo "Inspecting pushed image manifest..."
docker buildx imagetools inspect "${DOCKER_USER}/${IMAGE_NAME}:${TAG}" || true

echo "Done."