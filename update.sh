#!/bin/bash
# curl -sSL https://raw.githubusercontent.com/OstrichBot/pihole/master/update.sh | bash

# Remove Old Files
sudo rm /etc/pihole/regex.list
sudo rm /etc/pihole/adlists.list

# Download New Files
sudo wget -O /etc/pihole/adlists.list https://raw.githubusercontent.com/OstrichBot/pihole/master/adlists.list
sudo wget -O /etc/pihole/regex.list https://raw.githubusercontent.com/OstrichBot/pihole/master/regex.list

# Restart DNS for regex filters
pihole restartdns
