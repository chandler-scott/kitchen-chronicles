#!/bin/bash

APP_DIR="/app/kitchen-chronicles"

# Build app
echo "Building app..."
cd kitchen-chronicles
npm install
npm run build

# Ensure the deployment folder exists
sudo mkdir -p $APP_DIR

# Copy the build directory to deployment folder
sudo cp -R build/* $APP_DIR

sudo systemctl reload nginx

