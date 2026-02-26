#!/bin/sh
set -e

# Full stack: infra + ragent container (uses docker-compose.yaml)
docker compose -f docker-compose.yaml up -d