#!/bin/bash

# ==========================
# DEPENDENCY INSTALLATION

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

# Install wasm32-unknown-unknown target
rustup target install wasm32-unknown-unknown

# ==========================
# APPLICATION SETUP

# clone your frontend app repository to ~/potato-shooter
git clone https://github.com/jackinf/potato-shooter.git ~/potato-shooter
cd ~/potato-shooter

# compile wasm and copy to static folder
cargo build --target wasm32-unknown-unknown --release
wasm-bindgen target/wasm32-unknown-unknown/release/potato-shooter.wasm --out-dir static --web

# ==========================
# SERVER CONFIGURATION FOR FRONTEND APP

# Create a Symlink to Your Frontend App
sudo rm -rf /var/www/html
sudo ln -s ~/potato-shooter/static /var/www/html

# Set correct permissions and ownership
sudo chown -R www-data:www-data ~/potato-shooter/static
sudo chmod -R 755 ~/potato-shooter/static

# Configure Nginx to Serve the App
cat <<EOF | sudo tee /etc/nginx/sites-available/potato-shooter.conf
server {
    listen 80;
    root /var/www/html;
    index index.html;
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# TODO: brotli
#cat <<EOF | sudo tee /etc/nginx/sites-available/potato-shooter.conf
#server {
#    listen 80;
#    root /var/www/html;
#    index index.html;
#
#    # Enable Brotli compression
#    brotli on;
#    brotli_comp_level 6;
#    brotli_types text/plain text/css application/javascript application/json application/xml application/wasm;
#
#    # Serve pre-compressed .br files if available
#    location / {
#        try_files \$uri \$uri.br \$uri/ =404;
#        add_header Content-Encoding br;
#    }
#
#    # Serve .wasm files with Brotli compression
#    location ~* \.wasm$ {
#        add_header Content-Type application/wasm;
#        add_header Content-Encoding br;
#        try_files \$uri.br \$uri =404;
#    }
#}
#EOF

# Enable the new Nginx configuration
sudo ln -s /etc/nginx/sites-available/potato-shooter.conf /etc/nginx/sites-enabled/potato-shooter.conf
sudo rm /etc/nginx/sites-enabled/default

# Restart Nginx
sudo systemctl restart nginx

# ==========================
# MATCHBOX SERVER SETUP

# Start Matchbox in the background
nohup matchbox_server &

# Wait for Matchbox to start
sleep 5

# Fetch the external IP and set the environment variable
EXTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
MATCHBOX_SERVER_URL="ws://$EXTERNAL_IP:3536/extreme_bevy?next=2"

# Add the environment variable to .bashrc
echo "export MATCHBOX_SERVER_URL=$MATCHBOX_SERVER_URL" >> $HOME/.bashrc