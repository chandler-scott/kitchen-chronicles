#!/bin/bash

# Define the app directory
APP_DIR="/app/kitchen-chronicles"
SSL_DIR="/etc/nginx/ssl"

./build.sh

read -p "Do you want to generate SSL certificates? (y/n): " SETUP_CERT
if [[ $SETUP_CERT == "y" ]]; then
   echo "Generating certs!"
   ./generate_cert.sh
fi
# Install Nginx if it's not installed
if ! [ -x "$(command -v nginx)" ]; then
  echo "Nginx is not installed. Installing Nginx."
  sudo apt-get update
  sudo apt-get install -y nginx
  echo "Nginx installed successfully."
else
  echo "Nginx is already installed."
fi

# Ensure Nginx is started
sudo systemctl start nginx
sudo systemctl enable nginx

# Configure Nginx to Serve the React App over HTTPS
# Backup the original Nginx default configuration
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak

# Write a new configuration to serve the app over HTTPS
echo "server {
    listen 80;
    server_name athena.local;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name athena.local;

    ssl_certificate $SSL_DIR/athena.local.crt;
    ssl_certificate_key $SSL_DIR/athena.local.key;

    location / {
        root $APP_DIR;
        index index.html index.htm;
        try_files \$uri /index.html;
    }
}" | sudo tee /etc/nginx/sites-available/default

# Reload Nginx to apply the new configuration
sudo systemctl reload nginx

echo "Nginx has been configured to serve your React app over HTTPS with a self-signed certificate."

