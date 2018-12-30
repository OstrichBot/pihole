#!/bin/bash
wget -qO /usr/local/bin/pihole_update.sh https://raw.githubusercontent.com/OstrichBot/pihole/master/pihole_update.sh
chmod +x /usr/local/bin/pihole_update.sh
/usr/local/bin/pihole_update.sh
