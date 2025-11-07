#!/usr/bin/env bash
set -euo pipefail

cd /opt/discord-musicbot

if [[ $# -eq 0 ]]; then
  set -- npm run start
fi

required_vars=(
  "DISCORD_TOKEN"
  "DISCORD_CLIENT_ID"
  "DISCORD_CLIENT_SECRET"
  "LAVALINK_PASSWORD"
)

missing=()
for name in "${required_vars[@]}"; do
  if [[ -z "${!name:-}" ]]; then
    missing+=("$name")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  printf 'Error: missing required environment variables: %s\n' "${missing[*]}" >&2
  exit 1
fi

lavalink_dir="/opt/lavalink"
application_file="$lavalink_dir/application.yml"

generate_lavalink_config() {
  cat >"$application_file" <<CONFIG
server:
  port: ${LAVALINK_PORT:-2333}
  address: ${LAVALINK_SERVER_ADDRESS:-0.0.0.0}

lavalink:
  server:
    password: "${LAVALINK_PASSWORD}"
    playerUpdateInterval: 5
    statsTaskInterval: 60
    koe:
      useEpoll: true
      highPacketPriority: true
      bufferDurationMs: 400
      byteBufAllocator: "default"
    sources:
      bandcamp: true
      getyarn: true
      http: true
      odysee: true
      reddit: true
      soundcloud: true
      tiktok: true
      twitch: true
      vimeo: true
      yandex: true
      youtube: true
      local: false
    lavaplayer:
      nonAllocating: false
      frameBufferDuration: 5000
      youtubePlaylistLoadLimit: 6
      gc-warnings: true
      youtubeSearchEnabled: true
      odyseeSearchEnabled: true
      soundcloudSearchEnabled: true
      yandexMusicSearchEnabled: true

metrics:
  prometheus:
    enabled: ${LAVALINK_METRICS_ENABLED:-true}
    endpoint: /metrics

sentry:
  dsn: ""
  environment: ""

logging:
  file:
    path: ./logs/
  logback:
    rollingpolicy:
      max-file-size: 1GB
      max-history: 30
  level:
    root: INFO
    lavalink: INFO
CONFIG
}

cleanup() {
  if [[ -n "${cmd_pid:-}" ]]; then
    kill "$cmd_pid" 2>/dev/null || true
    wait "$cmd_pid" 2>/dev/null || true
  fi
  if [[ -n "${lavalink_pid:-}" ]]; then
    kill "$lavalink_pid" 2>/dev/null || true
    wait "$lavalink_pid" 2>/dev/null || true
  fi
}

trap cleanup INT TERM

enable_lavalink="${ENABLE_LAVALINK:-true}"
if [[ "${enable_lavalink,,}" != "false" ]]; then
  generate_lavalink_config
  (
    cd "$lavalink_dir"
    java -jar Lavalink.jar --spring.config.location="file:$application_file"
  ) &
  lavalink_pid=$!
fi

"$@" &
cmd_pid=$!
wait "$cmd_pid"
status=$?

if [[ -n "${lavalink_pid:-}" ]]; then
  kill "$lavalink_pid" 2>/dev/null || true
  wait "$lavalink_pid" 2>/dev/null || true
fi

exit "$status"
