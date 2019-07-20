#!/bin/bash
wget -qO /usr/local/bin/pihole_update.sh https://raw.githubusercontent.com/OstrichBot/pihole/master/pihole_update.sh
wget -q0 /etc/dnsmasq.d/02-dnssec.conf https://raw.githubusercontent.com/OstrichBot/pihole/master/dnsmasq.d/02-dnssec.conf
wget -q0 /etc/dnsmasq.d/04-servers.conf https://raw.githubusercontent.com/OstrichBot/pihole/master/dnsmasq.d/04-servers.conf
wget -q0 /etc/dnsmasq.d/03-interface.conf https://raw.githubusercontent.com/OstrichBot/pihole/master/dnsmasq.d/03-interface.conf
chmod +x /usr/local/bin/pihole_update.sh
/usr/local/bin/pihole_update.sh
