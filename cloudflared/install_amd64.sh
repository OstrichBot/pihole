#!/bin/bash
# Scripts CloudFlared Install
# REF: https://bendews.com/posts/implement-dns-over-https/

# Download latest cloudflared client from source
wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb
sudo apt-get install ./cloudflared-stable-linux-amd64.deb
sudo useradd -s /usr/sbin/nologin -r -M cloudflared

# Download cloudflared commandline parameters
wget -O /etc/default/cloudflared https://raw.githubusercontent.com/OstrichBot/pihole/master/cloudflared/cloudflared.arg
sudo chown cloudflared:cloudflared /etc/default/cloudflared
sudo chown cloudflared:cloudflared /usr/local/bin/cloudflared

# Download cloudflared.service & enable
wget -O /lib/systemd/system/cloudflared.service https://raw.githubusercontent.com/OstrichBot/pihole/master/cloudflared/cloudflared.service
sudo systemctl enable cloudflared
sudo systemctl start cloudflared

# Show that it worked
dig @127.0.0.1 -p 5053 google.com
