#!/bin/bash
clear
rm output.txt
while read url; do

        if [[ "$url" =~ ^#|^$ ]]; then
                echo ${url} >> output.txt
                continue
        fi
        echo -e "${url} #$(wget --server-response --spider "$url" 2>&1 | grep -P '(Last-Modified)' | grep -oP '[0-9][0-9].*[0-9][0-9][0-9][0-9]')" >> output.txt
done < /etc/pihole/adlists.list
