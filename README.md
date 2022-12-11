# Bot_project

## Create a Discord Application

Step 1: go to the [Discord Developer portal](https://discord.com/developers/applications)

Step 2: create a new application + bot

Step 3: create a bot invitelink using it's client id here

Step 4: save the bot token for later

## Bot


### Instalation
```
[etienne@bot ~]$ sudo dnf update
Complete!
[etienne@bot ~]$ sudo dnf install nodejs -y
Complete!
[etienne@bot ~]$ sudo dnf install git
Complete!
[etienne@bot ~]$ git clone -b v5 https://github.com/SudhanPlayz/Discord-MusicBot.git
Resolving deltas: 100% (2886/2886), done.
```


### Configuration du bot

```
[etienne@bot Discord-MusicBot]$ sudo nano config.js
        token: process.env.token || "YOUR_PERSONAL_TOKEN", //- Bot's Token
        clientId: process.env.clientId || "YOUR_PERSONAL_CLIENT_ID", //- ID of the bot
        clientSecret: process.env.clientSecret || "YOUR_PERSONAL_CLIENT_SECRET", //- Client Secret of the bot
        cookieSecret: "YOUR_OWN_SECRET_COOKIE",
        [...]
                nodes: [
                {
                        identifier: "Main Node", //- Used for indentifier in stats commands.
                        host: "localhost", //- The host name or IP of the lavalink server.
                        port: 8080, // The port that lavalink is listening to. This must be a number!
                        password: "YOUR_PASSWORD", //- The password of the lavalink server.
                        retryAmount: 200, //- The amount of times to retry connecting to the node if connection got dropped.
                        retryDelay: 40, //- Delay between reconnect attempts if connection is lost.
                        secure: false, //- Can be either true or false. Only use true if ssl is enabled!
                },
        ],
```

## Lavalink


### Instalation
```
[etienne@bot ~$ dnf search openjdk
Complete!
[etienne@bot ~]$ sudo dnf install java-17-openjdk java-17-openjdk-devel
Complete!
[etienne@bot ~]$ sudo dnf install npm -y
Complete!
```

### Recupération du Lavalink et de l'application
```
[etienne@bot ~]$ curl -SLO https://github.com/freyacodes/Lavalink/releases/download/3.4/Lavalink.jar
100 39.3M  100 39.3M    0     0  5471k      0  0:00:07  0:00:07 --:--:-- 5409k
[etienne@bot Discord-MusicBot]$ curl -SLO https://cdn.darrennathanael.com/jars/application.yml
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2197  100  2197    0     0   8930      0 --:--:-- --:--:-- --:--:--  8894
```

### Configuration de l'application.yml
```
[etienne@bot Discord-MusicBot]$ sudo cat application.yml
server: # REST and WS server
  port: 8080
  address: 0.0.0.0
[etienne@bot ~]$ sudo mv Lavalink.jar Discord-MusicBot/
[etienne@bot ~]$ sudo mv application.yml Discord-MusicBot/
```

### Firewall
```
[etienne@bot ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
[sudo] password for etienne:
success
[etienne@bot ~]$ sudo firewall-cmd --reload
```

## Commander pour lancer intialiser et lancer le bot
```
[etienne@bot Discord-MusicBot]$ npm install
npm notice
[etienne@bot Discord-MusicBot]$ npm run deploy
Successfully deployed commands!
[etienne@bot Discord-MusicBot]$ npm run start
```

## Le serveur

**Disclaimer le serveur de la solution ne fonctionne pas correctement notament du au chemin de fichier utiliser dans le code. De ce fait vous aurait un site web lancer mais il ne marchera pas avec le bot**

### Installation et configuration du serveur nginx
```
[etienne@bot ~]$ sudo dnf install nginx -y
[etienne@bot ~]$ sudo vim /etc/nginx/nginx.conf
[etienne@bot ~]$ cat /etc/nginx/nginx.conf
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

}
```

### Configuration du dashboard
```
[etienne@bot ~]$ cd Discord-MusicBot/dashboard/
[etienne@bot dashboard]$ npm install
found 0 vulnerabilities
[etienne@bot dashboard]$ npm run build
○  (Static)  automatically rendered as static HTML (uses no initial props)
[etienne@bot dashboard]$ npm run export
Export successful. Files written to /home/etienne/Discord-MusicBot/dashboard/o
```

### Ajout du serveur
```
[etienne@bot dashboard]$ sudo nano /etc/nginx/conf.d/musicbot.conf
[etienne@bot dashboard]$ cat /etc/nginx/conf.d/musicbot.conf
server {
    listen 80;
    server_name foo.bar;

    location / {
        proxy_set_header   X-Forwarded-For $remote_addr;
        proxy_set_header   Host $http_host;
        proxy_pass         http://127.0.0.1:3000;
    }
}
```

### Firewall
```
[etienne@bot dashboard]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[etienne@bot dashboard]$ sudo firewall-cmd --reload
success
```

### Lancement du serveur nginx
```
[etienne@bot ~]$ sudo systemctl enable nginx
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
[etienne@bot dashboard]$ sudo systemctl start nginx
[etienne@bot dashboard]$ sudo systemctl status nginx
     Active: active (running) since Thu 2022-12-08 10:54:46 CET; 29min ago
```

## Commande pour lancer le bot, le lavalink et sahboard (executer les commandes dans l'ordre ci-dessous)
```
[etienne@bot Discord-MusicBot]$ java -jar Lavalink.jar
[etienne@bot Discord-MusicBot]$ npm run start
[etienne@bot dashboard]$ npm run start
```

## Création des services


### Service lancement du bot
```
[etienne@bot ~]$ sudo nano /usr/bin/lance_le_bot.sh
[etienne@bot ~]$ cat /usr/bin/lance_le_bot.sh
cd LE_CHEMIN_DU_FICHIER/Discord-MusicBot
npm run start
[etienne@bot ~]$ sudo nano /etc/systemd/system/bot.service
[etienne@bot ~]$ cat /usr/bin/lance_le_bot.sh
cd /home/etienne/Discord-MusicBot
npm run start
[etienne@bot ~]$ cat /etc/systemd/system/bot.service
[Unit]
Description=Run the bot

[Service]
ExecStart=bash /usr/bin/lance_le_bot.sh

[Install]
WantedBy=multi-user.target
[etienne@bot ~]$ sudo systemctl daemon-reload
[etienne@bot ~]$ sudo systemctl start bot
[etienne@bot ~]$ sudo systemctl status bot
     Active: active (running) since Sun 2022-12-11 19:56:07 CET; 4s ago

```

### Service lancement du Lavalink
```
[etienne@bot ~]$ sudo cat /usr/bin/run_lavalink.sh
cd LE_CHEMIN_DU_FICHIER/Discord-MusicBot
java -jar Lavalink.jar
[etienne@bot ~]$ sudo cat /etc/systemd/system/lavalink.service
[Unit]
Description=Run the lavalink

[Service]
ExecStart=bash /usr/bin/run_lavalink.sh

[Install]
WantedBy=multi-user.target
[etienne@bot ~]$ sudo systemctl daemon-reload
[etienne@bot ~]$ sudo systemctl start lavalink
[etienne@bot ~]$ sudo systemctl status lavalink
     Active: active (running) since Sun 2022-12-11 20:09:45 CET; 7s ago
```

### Service lancement du Site Web
```
[etienne@bot ~]$ sudo nano /usr/bin/run_site_web.sh
[etienne@bot ~]$ sudo cat /usr/bin/run_site_web.sh
cd LE_CHEMIN_DU_FICHIER/Discord-MusicBot/dashboard
npm run start
[etienne@bot ~]$ sudo nano /etc/systemd/system/web.service
[etienne@bot ~]$ cat /etc/systemd/system/web.service
[Unit]
Description=Run the site web

[Service]
ExecStart=bash /usr/bin/run_site_web.sh

[Install]
WantedBy=multi-user.target
[etienne@bot ~]$ sudo systemctl start web
[etienne@bot ~]$ sudo systemctl status web
     Active: active (running) since Sun 2022-12-11 21:06:04 CET; 9s ago
```

