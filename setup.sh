#!/bin/bash

# Define the app directory
APP_DIR="/app/kitchen-chronicles"

# Step 1: Build the React App
echo "Building the React app..."
cd kitchen-chronicles
npm install
npm run build

# Ensure the app directory exists
sudo mkdir -p $APP_DIR

# Copy the build directory to the desired app directory
sudo cp -R build/* $APP_DIR

# Step 2: Install Nginx if it's not installed
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

# Step 3: Generate Self-Signed SSL Certificate
SSL_DIR="/etc/nginx/ssl"
sudo mkdir -p $SSL_DIR
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout $SSL_DIR/athena.local.key -out $SSL_DIR/athena.local.crt \
    -subj "/C=US/ST=Tennessee/L=Johnson City/O=chandler-scott/CN=athena.local"

# Step 4: Configure Nginx to Serve the React App over HTTPS
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

