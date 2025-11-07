# Bot_project

Ce dépôt propose une image Docker prête à l'emploi pour exécuter [Discord-MusicBot](https://github.com/SudhanPlayz/Discord-MusicBot) ainsi qu'un serveur [Lavalink](https://github.com/freyacodes/Lavalink). L'objectif est de pouvoir lancer rapidement le bot tout en restant capable de personnaliser le token et les paramètres principaux via des variables d'environnement.

## Prérequis

- Docker 20.10+ ou Podman 4+
- Un bot Discord configuré depuis le [Discord Developer Portal](https://discord.com/developers/applications) avec son token, son client ID et son client secret.

## Construction de l'image

```bash
# À exécuter à la racine du dépôt
docker build -t discord-musicbot:latest .
```

L'image télécharge automatiquement le code officiel du bot (branche `v5`), installe les dépendances Node.js et récupère Lavalink 4.0.6.

## Variables d'environnement disponibles

Les variables suivantes peuvent être passées à `docker run -e NOM=VALEUR ...` ou à un orchestrateur (Docker Compose, Kubernetes, etc.). Les variables marquées comme **obligatoires** doivent absolument être définies.

| Variable | Obligatoire | Valeur par défaut | Description |
|----------|-------------|-------------------|-------------|
| `DISCORD_TOKEN` | ✅ | – | Token du bot Discord. |
| `DISCORD_CLIENT_ID` | ✅ | – | Client ID du bot. |
| `DISCORD_CLIENT_SECRET` | ✅ | – | Client secret du bot. |
| `LAVALINK_PASSWORD` | ✅ | – | Mot de passe utilisé par Lavalink et par le bot. |
| `PORT` | ❌ | `3000` | Port utilisé par l'API/dashboard du bot. |
| `CMD_PER_PAGE` | ❌ | `10` | Nombre de commandes affichées par page pour l'aide. |
| `ADMIN_ID` | ❌ | `""` | Identifiant Discord qui aura les droits administrateur. |
| `SERVER_DEAFEN` | ❌ | `true` | Laisse le bot auto-sourdine. |
| `DEFAULT_VOLUME` | ❌ | `30` | Volume par défaut du bot (1–100). |
| `TWENTY_FOUR_SEVEN` | ❌ | `false` | Empêche le bot de quitter le salon vocal. |
| `AUTO_QUEUE` | ❌ | `false` | Active la mise en file automatique de chansons liées. |
| `AUTO_PAUSE` | ❌ | `true` | Met en pause quand tout le monde quitte le salon. |
| `DEBUG_MODE` | ❌ | `false` | Active les logs de debug. |
| `COOKIE_SECRET` | ❌ | `change-me` | Secret utilisé pour les cookies du tableau de bord. |
| `WEBSITE_URL` | ❌ | `http://localhost:3000` | URL publique du tableau de bord (sans slash final). |
| `SUPPORT_SERVER` | ❌ | `https://discord.gg/sbySMS7m3v` | Lien vers le serveur de support affiché par le bot. |
| `ISSUES_URL` | ❌ | `https://github.com/SudhanPlayz/Discord-MusicBot/issues` | Lien vers le suivi des bugs. |
| `DISCORD_SCOPES` | ❌ | `identify,guilds,applications.commands` | Liste de scopes OAuth2 séparés par des virgules. |
| `DISCORD_PERMISSIONS` | ❌ | `277083450689` | Permissions à utiliser lors de l'invitation du bot. |
| `DISCONNECT_TIME` | ❌ | `30000` | Temps en millisecondes avant la déconnexion automatique. |
| `EMBED_COLOR` | ❌ | `#2f3136` | Couleur hexadécimale utilisée dans les embeds. |
| `PRESENCE_STATUS` | ❌ | `online` | Statut du bot (`online`, `idle`, `dnd`, `invisible`). |
| `BOT_ACTIVITY_NAME` | ❌ | `Music` | Texte affiché dans l'activité. |
| `BOT_ACTIVITY_TYPE` | ❌ | `LISTENING` | Type d'activité (`PLAYING`, `WATCHING`, `LISTENING`, `STREAMING`). |
| `BOT_ACTIVITY_URL` | ❌ | – | URL utilisée uniquement si le type est `STREAMING`. |
| `ICON_URL` | ❌ | `https://cdn.darrennathanael.com/icons/spinning_disk.gif` | Icône utilisée dans les embeds. |
| `ENABLE_LAVALINK` | ❌ | `true` | Permet de désactiver le Lavalink intégré (utile si vous en utilisez un externe). |
| `LAVALINK_HOST` | ❌ | `localhost` | Hôte du Lavalink auquel se connecter. |
| `LAVALINK_PORT` | ❌ | `2333` | Port du Lavalink. |
| `LAVALINK_IDENTIFIER` | ❌ | `Main Node` | Nom affiché pour le nœud Lavalink. |
| `LAVALINK_RETRY_AMOUNT` | ❌ | `200` | Nombre de tentatives de reconnexion. |
| `LAVALINK_RETRY_DELAY` | ❌ | `40` | Délai en secondes entre les tentatives. |
| `LAVALINK_SECURE` | ❌ | `false` | Active TLS pour Lavalink si `true`. |
| `LAVALINK_SERVER_ADDRESS` | ❌ | `0.0.0.0` | Adresse d'écoute du Lavalink intégré. |
| `LAVALINK_METRICS_ENABLED` | ❌ | `true` | Active l'endpoint Prometheus du Lavalink. |

## Exemple de lancement

```bash
docker run -d \
  --name discord-musicbot \
  -p 3000:3000 \
  -p 2333:2333 \
  -e DISCORD_TOKEN="votre_token" \
  -e DISCORD_CLIENT_ID="votre_client_id" \
  -e DISCORD_CLIENT_SECRET="votre_client_secret" \
  -e LAVALINK_PASSWORD="motdepassefort" \
  discord-musicbot:latest
```

Le conteneur démarre alors deux processus :
- le bot Discord (`npm run start`),
- un serveur Lavalink Java configuré automatiquement via les variables d'environnement ci-dessus.

### Déploiement des commandes slash

Avant le premier démarrage (ou après toute modification des commandes), lancez la commande suivante pour enregistrer les commandes slash du bot :

```bash
docker run --rm \
  -e DISCORD_TOKEN="votre_token" \
  -e DISCORD_CLIENT_ID="votre_client_id" \
  -e DISCORD_CLIENT_SECRET="votre_client_secret" \
  -e LAVALINK_PASSWORD="motdepassefort" \
  discord-musicbot:latest npm run deploy
```

### Utilisation d'un Lavalink externe

Si vous possédez déjà un serveur Lavalink, positionnez `ENABLE_LAVALINK=false` et ajustez `LAVALINK_HOST`, `LAVALINK_PORT`, `LAVALINK_SECURE` et `LAVALINK_PASSWORD` pour pointer vers votre instance. Le conteneur ne démarrera alors que le bot Node.js.

## Fichiers de configuration hors Docker

Le dossier [`Fichier_conf`](Fichier_conf) contient :

- `config.js` – le même fichier de configuration utilisé dans l'image Docker. Il lit toutes les valeurs depuis les variables d'environnement et peut servir de base si vous exécutez le bot en dehors d'un conteneur.
- `application.yml` – configuration par défaut de Lavalink (mot de passe à remplacer) pour un déploiement manuel.

## Dépannage rapide

- **Erreur `Environment variable ... is required.`** : vérifiez que vous avez bien défini les variables d'environnement obligatoires (`DISCORD_TOKEN`, `DISCORD_CLIENT_ID`, `DISCORD_CLIENT_SECRET`, `LAVALINK_PASSWORD`).
- **Impossible de se connecter à Lavalink** : assurez-vous que le mot de passe et le port sont identiques côté bot et côté serveur Lavalink.
- **Les commandes slash n'apparaissent pas** : rejouez `npm run deploy` comme indiqué ci-dessus et attendez quelques minutes que Discord propage les commandes.

## Licence

Les fichiers originaux du bot et de Lavalink restent soumis à leurs licences respectives. Ce dépôt ne fait qu'automatiser leur installation et leur configuration.
