const required = (name) => {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Environment variable ${name} is required.`);
  }
  return value;
};

const parseNumber = (name, defaultValue) => {
  const raw = process.env[name];
  if (raw === undefined || raw === "") {
    return defaultValue;
  }

  const parsed = Number(raw);

  if (Number.isNaN(parsed)) {
    throw new Error(`Environment variable ${name} must be a valid number.`);
  }

  return parsed;
};

const parseBoolean = (name, defaultValue) => {
  const raw = process.env[name];
  if (raw === undefined || raw === "") {
    return defaultValue;
  }

  const normalized = raw.toString().trim().toLowerCase();
  if (["1", "true", "yes", "on"].includes(normalized)) {
    return true;
  }
  if (["0", "false", "no", "off"].includes(normalized)) {
    return false;
  }

  throw new Error(
    `Environment variable ${name} must be a boolean (true/false, 1/0, yes/no, on/off).`
  );
};

const parseList = (name, fallback) => {
  const raw = process.env[name];
  if (!raw) {
    return fallback;
  }

  return raw
    .split(",")
    .map((entry) => entry.trim())
    .filter(Boolean);
};

const parsePresenceActivities = () => {
  const activityName = process.env.BOT_ACTIVITY_NAME || "Music";
  const activityType = (process.env.BOT_ACTIVITY_TYPE || "LISTENING").toUpperCase();
  const activityUrl = process.env.BOT_ACTIVITY_URL;

  const activity = {
    name: activityName,
    type: activityType,
  };

  if (activityType === "STREAMING" && activityUrl) {
    activity.url = activityUrl;
  }

  return [activity];
};

module.exports = {
  cmdPerPage: parseNumber("CMD_PER_PAGE", 10),
  adminId: process.env.ADMIN_ID || "",
  token: required("DISCORD_TOKEN"),
  clientId: required("DISCORD_CLIENT_ID"),
  clientSecret: required("DISCORD_CLIENT_SECRET"),
  port: parseNumber("PORT", 3000),
  scopes: parseList("DISCORD_SCOPES", ["identify", "guilds", "applications.commands"]),
  serverDeafen: parseBoolean("SERVER_DEAFEN", true),
  defaultVolume: parseNumber("DEFAULT_VOLUME", 30),
  supportServer: process.env.SUPPORT_SERVER || "https://discord.gg/sbySMS7m3v",
  Issues: process.env.ISSUES_URL || "https://github.com/SudhanPlayz/Discord-MusicBot/issues",
  permissions: parseNumber("DISCORD_PERMISSIONS", 277083450689),
  disconnectTime: parseNumber("DISCONNECT_TIME", 30000),
  twentyFourSeven: parseBoolean("TWENTY_FOUR_SEVEN", false),
  autoQueue: parseBoolean("AUTO_QUEUE", false),
  autoPause: parseBoolean("AUTO_PAUSE", true),
  debug: parseBoolean("DEBUG_MODE", false),
  cookieSecret: process.env.COOKIE_SECRET || "change-me", // Replace before running in production
  website: process.env.WEBSITE_URL || "http://localhost:3000", // without the / at the end
  nodes: [
    {
      identifier: process.env.LAVALINK_IDENTIFIER || "Main Node",
      host: process.env.LAVALINK_HOST || "localhost",
      port: parseNumber("LAVALINK_PORT", 2333),
      password: required("LAVALINK_PASSWORD"),
      retryAmount: parseNumber("LAVALINK_RETRY_AMOUNT", 200),
      retryDelay: parseNumber("LAVALINK_RETRY_DELAY", 40),
      secure: parseBoolean("LAVALINK_SECURE", false),
    },
  ],
  embedColor: process.env.EMBED_COLOR || "#2f3136",
  presence: {
    status: (process.env.PRESENCE_STATUS || "online").toLowerCase(),
    activities: parsePresenceActivities(),
  },
  iconURL:
    process.env.ICON_URL || "https://cdn.darrennathanael.com/icons/spinning_disk.gif",
};
