#!/bin/bash
sudo rm /etc/pihole/regex.list
sudo rm /etc/pihole/adlists.list
sudo wget -O /etc/pihole/adlists.list https://raw.githubusercontent.com/OstrichBot/pihole/master/adlists.list
sudo wget -O /etc/pihole/regex.list https://raw.githubusercontent.com/OstrichBot/pihole/master/regex.list
pihole restartdns
