#!/bin/bash
# curl -sSL https://raw.githubusercontent.com/OstrichBot/pihole/master/update.sh | bash

# Advise User what we are doing
echo -e " \e[1m This script will download adlists.list & regex.list from the repo \e[0m"
sleep 1
echo -e "\n"

# Check for Root
if [ "$(id -u)" != "0" ] ; then
	echo "This script requires root permissions. Please run this as root!"
	exit 2
fi

# Stop PiHole
pihole disable

# Remove Old Files
rm /etc/pihole/regex.list
rm /etc/pihole/adlists.list

# Download New Files
wget -O /etc/pihole/adlists.list https://raw.githubusercontent.com/OstrichBot/pihole/master/adlists.list
wget -O /etc/pihole/regex.list https://raw.githubusercontent.com/OstrichBot/pihole/master/regex.list

# Restart DNS for regex filters
pihole restartdns
sleep 2

# Enable PiHole
pihole enable
sleep 2

# Gravity
pihole updateGravity
