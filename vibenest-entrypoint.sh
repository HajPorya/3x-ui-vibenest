#!/bin/sh
set -eu

# VibeNest and similar platforms conventionally expose PORT; upstream 3X-UI
# reads XUI_PORT. Honour an explicit XUI_PORT first, then PORT, then 8080.
XUI_PORT="${XUI_PORT:-${PORT:-8080}}"
export XUI_PORT

# VibeNest injects DATABASE_URL for managed PostgreSQL. Upstream expects
# XUI_DB_DSN and XUI_DB_TYPE. Never print the URL: it may contain credentials.
if [ -z "${XUI_DB_DSN:-}" ] && [ -n "${DATABASE_URL:-}" ]; then
    XUI_DB_DSN="$DATABASE_URL"
fi

if [ -n "${XUI_DB_DSN:-}" ]; then
    XUI_DB_TYPE="${XUI_DB_TYPE:-postgres}"
    export XUI_DB_DSN XUI_DB_TYPE
fi

exec /app/DockerEntrypoint.sh "$@"
