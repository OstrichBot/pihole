#!/bin/bash
# curl -sSL https://raw.githubusercontent.com/OstrichBot/pihole/master/update.sh | bash
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

# Remove Old Files
rm /etc/pihole/regex.list
rm /etc/pihole/adlists.list
echo -e " ${TICK} \e[32m Removing Files... \e[0m"
sleep 0.5

# Download New Files
echo -e " [...] \e[32m Downloading new files... \e[0m"
wget -O /etc/pihole/adlists.list https://raw.githubusercontent.com/OstrichBot/pihole/master/adlists.list
wget -O /etc/pihole/regex.list https://raw.githubusercontent.com/OstrichBot/pihole/master/regex.list
wait
echo -e " ${TICK} \e[32m Download Complete \e[0m"

# Restart DNS for regex filters
pihole restartdns
sleep 5

# Gravity
echo -e " [...] \e[32m Pi-hole gravity rebuilding lists. This may take a while... \e[0m"
pihole -g > /dev/null
wait
echo -e " ${TICK} \e[32m Pi-hole's gravity updated \e[0m"
echo -e " ${TICK} \e[32m Done! \e[0m"
