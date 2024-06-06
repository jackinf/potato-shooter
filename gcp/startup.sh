#!/bin/bash

# Update package lists and install necessary tools
sudo apt-get update
sudo apt-get install -y build-essential curl

# Install Rust and Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Install Matchbox
cargo install matchbox_server

# Install Nginx (Web Server)
sudo apt-get install -y nginx

# TODO: clone your frontend app repository to ~/potato-shooter

# Create a Symlink to Your Frontend App
sudo ln -s ~/potato-shooter/static /var/www/html

# Configure Nginx to Serve the App
cat <<EOF | sudo tee /etc/nginx/sites-available/potato-shooter.conf
server {
    listen 80;
    server_name your-matchbox-domain.com;
    root /var/www/html;
    index index.html;
    location / {
        try_files $uri $uri/ =404;
    }
}
EOF
sudo ln -s /etc/nginx/sites-available/potato-shooter.conf /etc/nginx/sites-enabled/potato-shooter.conf

# Restart Nginx
sudo systemctl restart nginx

# Start Matchbox
matchbox_server &