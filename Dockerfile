# Container image for Discord-MusicBot with Lavalink
FROM node:18-bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        curl \
        ca-certificates \
        openjdk-17-jre-headless \
        tini \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/discord-musicbot

ARG DISCORD_MUSICBOT_REPO=https://github.com/SudhanPlayz/Discord-MusicBot.git
ARG DISCORD_MUSICBOT_REF=v5

RUN git clone --depth 1 -b "$DISCORD_MUSICBOT_REF" "$DISCORD_MUSICBOT_REPO" /opt/discord-musicbot

COPY Fichier_conf/config.js ./config.js

RUN npm install --omit=dev

RUN mkdir -p /opt/lavalink \
    && curl -L -o /opt/lavalink/Lavalink.jar \
        https://github.com/freyacodes/Lavalink/releases/download/4.0.6/Lavalink.jar

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENV NODE_ENV=production \
    ENABLE_LAVALINK=true \
    CMD_PER_PAGE=10 \
    SERVER_DEAFEN=true \
    DEFAULT_VOLUME=30 \
    SUPPORT_SERVER=https://discord.gg/sbySMS7m3v \
    ISSUES_URL=https://github.com/SudhanPlayz/Discord-MusicBot/issues \
    DISCORD_PERMISSIONS=277083450689 \
    DISCONNECT_TIME=30000 \
    TWENTY_FOUR_SEVEN=false \
    AUTO_QUEUE=false \
    AUTO_PAUSE=true \
    DEBUG_MODE=false \
    COOKIE_SECRET=change-me \
    WEBSITE_URL=http://localhost:3000 \
    LAVALINK_IDENTIFIER="Main Node" \
    LAVALINK_HOST=localhost \
    LAVALINK_PORT=2333 \
    LAVALINK_RETRY_AMOUNT=200 \
    LAVALINK_RETRY_DELAY=40 \
    LAVALINK_SECURE=false \
    EMBED_COLOR=#2f3136 \
    PRESENCE_STATUS=online \
    BOT_ACTIVITY_NAME=Music \
    BOT_ACTIVITY_TYPE=LISTENING \
    LAVALINK_SERVER_ADDRESS=0.0.0.0 \
    LAVALINK_METRICS_ENABLED=true

ENTRYPOINT ["tini", "--", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["npm", "run", "start"]
