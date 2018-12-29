#!/bin/bash
# Based on: 
# 	https://github.com/anudeepND/whitelist
# 	https://github.com/mmotti/pihole-gravity-optimise
#
# License: 	https://github.com/OstrichBot/pihole/blob/master/LICENSE
# Source:	https://raw.githubusercontent.com/OstrichBot/pihole/master/update_pihole.sh
# Updated: 	29DEC2018
# Reason:	Development & clean-up	

# Set file variables
file_gravity="/etc/pihole/gravity.list"
dir_wildcards="/etc/dnsmasq.d"
file_regex="/etc/pihole/regex.list"

# Define a check mark
TICK="[\e[32m✔\e[0m]"

# https://github.com/mmotti/pihole-gravity-optimise/blob/master/gravityOptimise.sh
# Function Code for regex reduction of gravity.list
process_regex ()
{
	# Check gravity.list is not empty
	if [ ! -s $file_gravity ]; then
			echo -e "  [\e[31mX\e[0m]\e[32m gravity.list is empty or does not exist\e[0m"
			return 1
	fi

	# Count gravity entries
	count_gravity=$(wc -l < $file_gravity)

	# Only read it if it exists and is not empty
	if [ -s $file_regex ]; then
		regexList=$(grep '^[^#]' $file_regex)
	else
		echo -e "  [\e[31mX\e[0m]\e[32m Regex list is empty or does not exist.\e[0m"
		return 1
	fi

	# Status update
	echo -e "  [i] \e[0m$(wc -l <<< "$regexList") \e[32mregexps found.\e[0m"

	# Invert match regex patterns against gravity.list
	echo -e "  [i]\e[32m Identifying unnecessary domains.\e[0m"
	new_gravity=$(grep -vEf <(echo "$regexList") $file_gravity)

	# If there are no domains after regex removals
	if [ -z "$new_gravity" ]; then
		echo -e "  [\e[31mX\e[0m]\e[32m No unnecessary domains were found\e[0m"
		return 0
	fi

	# Status update
	echo -e "  [i]\e[32m gravity.list contains \e[0m$(($count_gravity-$(wc -l <<< "$new_gravity"))) \e[32munnecessary hosts\e[0m"

	# Output file
	echo -e "  [i]\e[32m Updating $file_gravity\e[0m"
	echo "$new_gravity" | sudo tee $file_gravity > /dev/null
	
	return 0
}

# Wipe the Screen
clear

# Advise User what we are doing
echo -e " \e[1m This script will update PiHole files from the repos at: \e[0m"
echo -e " \e[1m     https://github.com/OstrichBot/pihole\e[0m\n"

# Check for Root
if [ "$(id -u)" != "0" ] ; then
	echo "This script requires root permissions. Please run this as root!"
	echo " \e[31m CAUTION: Read through the script before doing so! \e[0m"
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
  echo -e " ${TICK}\e[32m Finished \e[0m"
fi

# Remove Old Files
echo -e "  ${TICK}\e[32m Removing Files... \e[0m"
rm /etc/pihole/regex.list
rm /etc/pihole/adlists.list
wait

# adlists.list
echo -e "  ${TICK}\e[32m Downloading adlists.list... \e[0m"
wget -O /etc/pihole/adlists.list https://raw.githubusercontent.com/OstrichBot/pihole/master/adlists.list > /dev/null 2>&1
wait

# regex.list
echo -e "  ${TICK}\e[32m Downloading regex.list... \e[0m"
wget -O /etc/pihole/regex.list https://raw.githubusercontent.com/OstrichBot/pihole/master/regex.list > /dev/null 2>&1
wait

# whitelist.txt
echo -e "  ${TICK}\e[32m Updating Whitelists... \e[0m"
curl -sS https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt | sudo tee -a /etc/pihole/whitelist.txt >/dev/null
curl -sS https://raw.githubusercontent.com/OstrichBot/pihole/master/whitelist.txt | sudo tee -a /etc/pihole/whitelist.txt >/dev/null
wait
echo -e "  ${TICK}\e[32m Removing Whitelist duplicates... \e[0m\n"
sudo gawk -i inplace '!a[$0]++' /etc/pihole/whitelist.txt
wait

# Update pihole
# This will update gravity.list
pihole updatePihole

# Restart DNS 
pihole restartdns

# Update Gravity
echo -e "  [o]\e[32m Pi-hole gravity rebuilding lists. \e[0m\e[31m This may take a while... \e[0m"
pihole -g > /dev/null
wait

# Reduce gravity.list by removing regex coverage
echo -e "  [o]\e[32m Removing gravity entries covered by regex. \e[0m\e[31m This may take a while... \e[0m"
process_regex

# Provide stats on block lists
echo -en "  [i]\e[32m whitelist.txt entries: \e[0m"
more /etc/pihole/whitelist.txt | grep -v "#" | wc -l
echo -en "  [i]\e[32m gravity.list entries: \e[0m"
more /etc/pihole/gravity.list | grep -v "#" | wc -l
echo -en "  [i]\e[32m regex.list entries: \e[0m"
more /etc/pihole/regex.list | grep -v "#" | wc -l

# Display PiHsedole status
pihole status
echo -e "  ${TICK}\e[32m Done! \e[0m\n"
