# Bot_project

# TP5: Bot Music Discord

Installation Bot
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
```

Installation Server
```
[etienne@server ~]$ sudo dnf update -y
Complete!
[etienne@server ~]$ dnf search openjdk
Complete!
[etienne@server ~]$ curl -SLO https://github.com/freyacodes/Lavalink/releases/download/3.4/Lavalink.jar
100 39.3M  100 39.3M    0     0  5471k      0  0:00:07  0:00:07 --:--:-- 5409k
[etienne@server ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
[sudo] password for etienne:
success
[etienne@server ~]$ sudo firewall-cmd --reload
[etienne@server ~]$ sudo dnf install -y tar
[etienne@server ~]$ tar xvzf ngrok-v3-stable-linux-amd64.tgz
```
