#!/usr/bin/env bash
# Bash script that sets up your web servers for the deployment of web_static.

# Install Nginx if it not already installed

if ! dpkg -s nginx &> /dev/null
then
    sudo apt-get -y update
    sudo apt-get -y install nginx
fi

# Starting Nginx web server
sudo nginx

# Create the folder /data/ if it doesn’t already exist
mkdir -p /data/

# Create the folder /data/web_static/ if it doesn’t already exist
mkdir -p /data/web_static/

# Create the folder /data/web_static/releases/ if it doesn’t already exist
mkdir -p /data/web_static/releases/

# Create the folder /data/web_static/shared/ if it doesn’t already exist
mkdir -p /data/web_static/shared/

# Create the folder /data/web_static/releases/test/ if it doesn’t already exist
mkdir -p /data/web_static/releases/test

# Create a fake HTML file /data/web_static/releases/test/index.html
echo 'Hello World!' > /data/web_static/releases/test/index.html

# Create a symbolic link /data/web_static/current linked to the /data/web_static/releases/test/ folder.
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Give ownership of the /data/ folder to the ubuntu user AND group.
chown -hR 204421:204421 /data/

# Update the Nginx configuration to serve the content of /data/web_static/current/ to hbnb_static.
# The configuration will look like this:
# server {
#    location /hbnb_static/ {
#        alias /data/web_static/current/;
#    }
# }
printf %s "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By $HOSTNAME;
    root   /var/www/html;
    index  index.html index.htm;
    location /hbnb_static {
        alias /data/web_static/current;
        index index.html index.htm;
    }
    location /redirect_me {
        return 301 https://www.youtube.com/watch?v=DHITmcKUGik;
    }
    error_page 404 /404.html;
    location /404 {
      root /var/www/html;
      internal;
    }
}" > /etc/nginx/sites-available/default

# Restarting Nginx
sudo nginx -s reload
