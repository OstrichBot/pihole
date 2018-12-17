#!/bin/bash
# curl -sSL https://raw.githubusercontent.com/OstrichBot/pihole/master/update.sh | bash

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
