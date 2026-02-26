#!/bin/sh
set -e

# Dev stack: only infra services, app runs in IDE (uses docker-compose-dev.yaml)
docker compose -f docker-compose-dev.yaml up -d