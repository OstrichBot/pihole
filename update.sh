#!/bin/bash
# curl -sSL https://raw.githubusercontent.com/OstrichBot/pihole/master/update.sh | bash

# Set Tick Art
TICK="[\e[32m ✔ \e[0m]"

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
echo -e " ${TICK} \e[32m Disabling PiHole... \e[0m"
pihole disable

# Remove Old Files
echo -e " ${TICK} \e[32m Removing Old Files... \e[0m"
rm /etc/pihole/regex.list
rm /etc/pihole/adlists.list

# Download New Files
echo -e " $[...] \e[32m Downloading Files... \e[0m"
wget -O /etc/pihole/adlists.list https://raw.githubusercontent.com/OstrichBot/pihole/master/adlists.list
wget -O /etc/pihole/regex.list https://raw.githubusercontent.com/OstrichBot/pihole/master/regex.list

# Restart DNS for regex filters
echo -e " ${TICK} \e[32m Restarting DNS... \e[0m"
pihole restartdns

# Enable PiHole
echo -e " ${TICK} \e[32m Enabling PiHole... \e[0m"
pihole enable

# Done
echo -e " ${TICK} \e[32m Done! \e[0m"
echo -e "\n\n"
