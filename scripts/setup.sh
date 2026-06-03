#!/bin/sh
# Start (or stop) local Docker infrastructure for Ragent.
# Default: Postgres, Redis, RustFS, RocketMQ — no Ollama (use Bailian + SiliconFlow in .env.local).

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMPOSE_FILE="${ROOT}/resources/docker/demo/docker-compose.yml"
COMPOSE=(docker compose -f "${COMPOSE_FILE}")

usage() {
  cat <<'EOF'
Usage: bin/setup.sh [options]

  Start middleware required by application.yaml (rag.vector.type=pg).

Options:
  --down, -d     Stop and remove containers (volumes kept)
  --status, -s   Show compose service status
  --ollama       Also start Ollama (profile "ollama", port 11434)
  --logs         Follow logs (all services, or pass service names)
  -h, --help     Show this help

Examples:
  bin/setup.sh
  bin/setup.sh --ollama
  bin/setup.sh --down
  set -a && source .env && set +a && ./mvnw -pl bootstrap -am spring-boot:run

API keys (not read from .env by Spring automatically):
  export BAILIAN_API_KEY=...
  export SILICONFLOW_API_KEY=...
  or: set -a && source .env && set +a
EOF
}

log() { printf '==> %s\n' "$*"; }
warn() { printf '!! %s\n' "$*" >&2; }

wait_postgres() {
  local i=0
  until docker exec ragent-demo-postgres pg_isready -U postgres -d ragent >/dev/null 2>&1; do
    i=$((i + 1))
    if [[ $i -gt 60 ]]; then
      warn "Postgres not ready after 120s. Check: docker logs ragent-demo-postgres"
      exit 1
    fi
    sleep 2
  done
  log "Postgres is ready (schema/init on first boot)."
}

wait_rocketmq() {
  local i=0
  until docker exec ragent-demo-rmqnamesrv sh -c \
    "grep -q 'The Name Server boot success' /home/rocketmq/logs/rocketmqlogs/namesrv.log 2>/dev/null"; do
    i=$((i + 1))
    if [[ $i -gt 45 ]]; then
      warn "RocketMQ NameServer slow to start; backend may retry. Check: docker logs ragent-demo-rmqnamesrv"
      return 0
    fi
    sleep 2
  done
  log "RocketMQ NameServer is up."
}

cmd_up() {
  local with_ollama="${1:-false}"
  local services=(postgres redis rustfs rmqnamesrv rmqbroker)

  if ! command -v docker >/dev/null 2>&1; then
    warn "docker not found in PATH"
    exit 1
  fi

  log "Starting Ragent infrastructure from ${COMPOSE_FILE}"
  if [[ "${with_ollama}" == "true" ]]; then
    "${COMPOSE[@]}" --profile ollama up -d
  else
    "${COMPOSE[@]}" up -d "${services[@]}"
  fi

  wait_postgres
  wait_rocketmq

  log "Running containers:"
  "${COMPOSE[@]}" ps

  echo ""
  log "Middleware ports"
  printf '  Postgres   5432  (user/pass/db: postgres/postgres/ragent)\n'
  printf '  Redis      6379  (password: 123456)\n'
  printf '  RustFS     9000  (keys: rustfsadmin / rustfsadmin)\n'
  printf '  RocketMQ   9876\n'
  if [[ "${with_ollama}" == "true" ]]; then
    printf '  Ollama     11434\n'
  fi

  echo ""
  log "Next steps (from repo root)"
  printf '  1) Load API keys:  set -a && source .env && set +a\n'
  printf '  2) Backend:        ./mvnw -pl bootstrap -am spring-boot:run\n'
  printf '  3) MCP (optional): ./mvnw -pl mcp-server -am spring-boot:run\n'
  printf '  4) Frontend:       cd frontend && npm install && npm run dev\n'
  printf '  Admin login (init data): admin / admin\n'

  if [[ -f "${ROOT}/.env" ]]; then
    log ".env found — remember to source it before starting Java (Spring does not auto-load .env)."
  else
    warn "No .env at repo root. Set BAILIAN_API_KEY and SILICONFLOW_API_KEY before run."
  fi

  if curl -sf http://127.0.0.1:11434/api/tags >/dev/null 2>&1 && [[ "${with_ollama}" != "true" ]]; then
    warn "Something is already listening on 11434 (host Ollama?). Not required if using cloud keys only."
  fi
}

cmd_down() {
  log "Stopping Ragent infrastructure..."
  "${COMPOSE[@]}" --profile ollama down
  log "Stopped (named volumes preserved)."
}

cmd_status() {
  "${COMPOSE[@]}" ps -a
}

cmd_logs() {
  shift || true
  if [[ $# -gt 0 ]]; then
    "${COMPOSE[@]}" logs -f "$@"
  else
    "${COMPOSE[@]}" logs -f
  fi
}

main() {
  local action=up
  local with_ollama=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --down|-d) action=down ;;
      --status|-s) action=status ;;
      --logs) action=logs; shift; cmd_logs "$@"; exit 0 ;;
      --ollama) with_ollama=true ;;
      -h|--help) usage; exit 0 ;;
      *)
        warn "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
    shift
  done

  case "${action}" in
    up) cmd_up "${with_ollama}" ;;
    down) cmd_down ;;
    status) cmd_status ;;
  esac
}

main "$@"
