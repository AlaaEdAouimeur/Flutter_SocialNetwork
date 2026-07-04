#!/usr/bin/env bash
# Starts the training + FastAPI/WebSocket server locally and exposes it
# through an ngrok tunnel so you can watch training live from a phone.
#
# Requires: `ngrok` installed and authenticated (ngrok config add-authtoken ...)
#
# Usage: ./scripts/start_with_ngrok.sh [port]

set -euo pipefail

PORT="${1:-8000}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Starting robot-soccer server on port ${PORT}..."
python -m server.run &
SERVER_PID=$!

cleanup() {
  echo "Stopping server (pid ${SERVER_PID})..."
  kill "${SERVER_PID}" 2>/dev/null || true
}
trap cleanup EXIT

# Give uvicorn a moment to bind before ngrok tries to reach it.
sleep 3

echo "Launching ngrok tunnel to http://localhost:${PORT} ..."
echo "Open the printed https://*.ngrok-free.app URL on your phone to watch training."
ngrok http "${PORT}"
