#!/bin/bash
# curl -sSL https://raw.githubusercontent.com/OstrichBot/pihole/master/update.sh | bash
TICK="[\e[32m ✔ \e[0m]"

# Wipe the Screen
clear

# Advise User what we are doing
echo -e " \e[1m This script will update adlists.list, regex.list and whitelist.txt from the repos \e[0m"
sleep 1
echo -e "\n"

# Check for Root
if [ "$(id -u)" != "0" ] ; then
	echo "This script requires root permissions. Please run this as root!"
	exit 2
fi

# Check which gawk
if ! (which gawk > /dev/null); then
  echo -e " [...] \e[32m Installing gawk... \e[0m"
  if (which apt-get > /dev/null); then
       apt-get install gawk -qq > /dev/null
  elif (which pacman > /dev/null); then
       pacman -Sqy gawk > /dev/null
  elif (which dnf > /dev/null); then
       dnf install gawk > /dev/null
  fi
  wait
  echo -e " ${TICK} \e[32m Finished \e[0m"
fi

# Remove Old Files
echo -e " ${TICK} \e[32m Removing Files... \e[0m"
rm /etc/pihole/regex.list
rm /etc/pihole/adlists.list
sleep 0.5

# adlists.list
echo -e " ${TICK} \e[32m Downloading adlists.list... \e[0m"
wget -O /etc/pihole/adlists.list https://raw.githubusercontent.com/OstrichBot/pihole/master/adlists.list > /dev/null 2>&1
wait

# regex.list
echo -e " ${TICK} \e[32m Downloading regex.list... \e[0m"
wget -O /etc/pihole/regex.list https://raw.githubusercontent.com/OstrichBot/pihole/master/regex.list > /dev/null 2>&1
wait

# whitelist.txt
echo -e " ${TICK} \e[32m Updating Whitelists... \e[0m"
curl -sS https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt | sudo tee -a /etc/pihole/whitelist.txt >/dev/null
curl -sS https://raw.githubusercontent.com/OstrichBot/pihole/master/whitelist.txt | sudo tee -a /etc/pihole/whitelist.txt >/dev/null
wait
echo -e " ${TICK} \e[32m Removing Whitelist duplicates... \e[0m"
sudo gawk -i inplace '!a[$0]++' /etc/pihole/whitelist.txt
wait

# Restart DNS 
echo -e " ${TICK} \e[32m Restarting PiHole... \e[0m"
pihole restartdns > /dev/null
sleep 5

# Update Gravity
echo -e " [...] \e[32m Pi-hole gravity rebuilding lists. This may take a while... \e[0m"
pihole -g > /dev/null
wait
echo -e " ${TICK} \e[32m Pi-hole's gravity updated. \e[0m"
echo -e " ${TICK} \e[32m Done! \e[0m"
echo -e "\n\n"
