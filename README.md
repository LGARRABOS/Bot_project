# Bot_project

## Create a Discord Application

Step 1: go to the [Discord Developer portal](https://discord.com/developers/applications)

Step 2: create a new application + bot

Step 3: create a bot invitelink using it's client id here

Step 4: save the bot token for later

## Install nodejs & npm (Bot Machine)

```
[etienne@bot ~]$ sudo dnf update
Complete!
[etienne@bot ~]$ sudo dnf install nodejs -y
Complete!
[etienne@bot ~]$ sudo dnf install git
Complete!
[etienne@bot ~]$ git clone -b v5 https://github.com/SudhanPlayz/Discord-MusicBot.git
Resolving deltas: 100% (2886/2886), done.
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

## Install Lavalink (Serveur Machine)
```
[etienne@bot ~$ dnf search openjdk
Complete!
[etienne@bot ~]$ sudo dnf install java-17-openjdk java-17-openjdk-devel
Complete!
[etienne@bot ~]$ curl -SLO https://github.com/freyacodes/Lavalink/releases/download/3.4/Lavalink.jar
100 39.3M  100 39.3M    0     0  5471k      0  0:00:07  0:00:07 --:--:-- 5409k
[etienne@bot ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
[sudo] password for etienne:
success
[etienne@bot ~]$ sudo firewall-cmd --reload
[etienne@bot ~]$ sudo dnf install -y tar
[etienne@bot Discord-MusicBot]$ java -jar Lavalink.jar

[etienne@bot Discord-MusicBot]$ curl -SLO https://cdn.darrennathanael.com/jars/application.yml
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2197  100  2197    0     0   8930      0 --:--:-- --:--:-- --:--:--  8894
[etienne@bot Discord-MusicBot]$ sudo cat application.yml
server: # REST and WS server
  port: 8080
  address: 0.0.0.0
[etienne@bot ~]$ sudo mv Lavalink.jar Discord-MusicBot/
[etienne@bot ~]$ sudo mv application.yml Discord-MusicBot/
```

```
[etienne@bot Discord-MusicBot]$ npm install
npm notice
[etienne@bot Discord-MusicBot]$ npm run deploy
Successfully deployed commands!
[etienne@bot Discord-MusicBot]$ npm run start
```

# Server bot

```
[etienne@server ~]$ sudo dnf update -y
Complete!
[etienne@server ~]$ sudo dnf install nginx -y
Complete!
[etienne@server ~]$ sudo dnf install -y tar
Complete!
[etienne@server ~]$ curl -SLO https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
[etienne@server ~]$ tar xvzf ngrok-v3-stable-linux-amd64.tgz
ngrok
[etienne@server ~]$ chmod +x ngrok
[etienne@server ~]$ sudo mv ngrok /usr/local/bin/
sudo mv ngrok /usr/local/bin/
[etienne@server ~]$ ngrok config add-authtoken 2IJGbuhtB3xfsEoY3ZpaiHL4mnB_5RZUiAB5YeV59HepLK6M
Authtoken saved to configuration file: /home/etienne/.config/ngrok/ngrok.yml
[etienne@server ~]$ cd /etc/nginx
[etienne@server nginx]$ sudo mkdir sites-available
[etienne@server nginx]$ ls
sites-available
[etienne@server nginx]$ sudo nano /etc/nginx/sites-available/musicbot.conf
[etienne@server nginx]$ sudo cat /etc/nginx/sites-available/musicbot.conf
server {
    listen 80;
    server_name webBot;

    location / {
        proxy_set_header   X-Forwarded-For $remote_addr;
        proxy_set_header   Host $http_host;
        proxy_pass         http://127.0.0.1:3000;
    }
}
[etienne@server nginx]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[etienne@server nginx]$ sudo firewall-cmd --reload
success
[etienne@server nginx]$ sudo systemctl start nginx
[etienne@server nginx]$ sudo systemctl status nginx
[etienne@server ~]$ sudo dnf install git -y
Complete!
[etienne@server ~]$ git clone https://github.com/SudhanPlayz/Discord-MusicBot.git
```
