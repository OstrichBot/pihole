#!/bin/bash
# Scripts CloudFlared Install
# REF: https://bendews.com/posts/implement-dns-over-https/

# Set variables for echo
TICK="[\e[32m✔\e[0m]"
CROSS="[\e[31mX\e[0m]"

# Wipe the Screen
clear

# Advise User what we are doing
echo -e " \e[1m This script will install cloudflared & configure PiHole to use it: \e[0m"

# Check for Root // Warn Users
if [ "$(id -u)" != "0" ] ; then
	echo -e "This script requires root permissions. Please run this as root!"
	echo -e " \e[31m CAUTION: Read through the script before doing so! \e[0m"
	exit 2
fi

# Create Install Folder
mkdir ~/cloudflared_src
cd ~/cloudflared_src

# Window dressing
echo -e "  ${TICK}\e[32m Checking CPU type... \e[0m"

# Install ARM packages
if [[ "$(dpkg --print-architecture)" =~ ^arm ]]; then
	echo -e "  ${TICK}\e[32m Downloading ARM cloudflared... \e[0m"
	sudo wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-arm.tgz
	echo -e "  [o]\e[32m Installing cloudflared... \e[0m"
	sudo tar -xvzf cloudflared-stable-linux-arm.tgz
	sudo cp ./cloudflared /usr/local/bin
	sudo chmod +x /usr/local/bin/cloudflared
fi

# Download latest cloudflared client from source AMD
if [[ "$(dpkg --print-architecture)" =~ ^amd ]]; then
	echo -e "  ${TICK}\e[32m Downloading AMD64 cloudflared... \e[0m"
	sudo wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb > /dev/null 2>&1
	echo -e "  [o]\e[32m Installing cloudflared... \e[0m"
	sudo apt-get install ./cloudflared-stable-linux-amd64.deb > /dev/null
fi

# Create User
if id cloudflared >/dev/null 2>&1; then
        echo -e "  ${CROSS}\e[32m User cloudflared exists... \e[0m"
else
        echo -e "  ${TICK}\e[32m Creating user cloudflared... \e[0m"
	sudo useradd -s /usr/sbin/nologin -r -M cloudflared > /dev/null
fi

# Download cloudflared commandline parameters
sudo wget -O /etc/default/cloudflared https://raw.githubusercontent.com/OstrichBot/pihole/master/cloudflared/cloudflared.arg > /dev/null 2>&1
sudo chown cloudflared:cloudflared /etc/default/cloudflared
sudo chown cloudflared:cloudflared /usr/local/bin/cloudflared

# Download cloudflared.service & enable
sudo wget -O /lib/systemd/system/cloudflared.service https://raw.githubusercontent.com/OstrichBot/pihole/master/cloudflared/cloudflared.service > /dev/null 2>&1
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
echo -e "  ${TICK}\e[32m Done... \e[0m"

# Remark out server entries in dnsmasq.d
echo -e "  ${TICK}\e[32m Updating dnsmasq.d files... \e[0m"
sudo sed -i 's/server=/#server=/g' /etc/dnsmasq.d/*.conf

# Update insert config in dnsmasq.d that directs PiHole to use CloudFlared
wget -O /etc/dnsmasq.d/50-cloudflared.conf https://raw.githubusercontent.com/OstrichBot/pihole/master/cloudflared/50-cloudflared.conf > /dev/null 2>&1

# Remove entries from PiHole setup variables
echo -e "  ${TICK}\e[32m Updating Pi-Hole files... \e[0m"
sudo sed -i 's/PIHOLE_DNS/#PIHOLE_DNS/g' /etc/pihole/setupVars.conf

# Restart PiHole
echo -e "  ${TICK}\e[32m Restarting PiHole... \e[0m"
pihole restartdns

# Display PiHole Output
echo -e "  ${TICK}\e[32m Done... \e[0m"
echo -e "  ${TICK}\e[32m Display PiHole DNS result... \e[0m\n"
dig @127.0.0.1 -p 53 google.com
