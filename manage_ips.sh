#!/bin/bash

# Function to fetch the list of countries and their codes
fetch_countries() {
    echo "Fetching country codes from iwik.org..."
    curl -s https://www.iwik.org/ipcountry/ | grep -oP '(?<=<a href="ipcountry/)\w{2}(?=")' | sort -u > countries.txt
}

# Fetch the list of countries
fetch_countries

# Show available countries
echo "Available countries to manage (enter their 2-letter code):"
cat countries.txt

# Read user input for action
read -p "Enter the 2-letter codes of the countries you want to manage (comma-separated, e.g., IS,CN): " input
IFS=',' read -r -a selected_countries <<< "$input"

# Read user action
echo "Choose an action:"
echo "1) Block IPs"
echo "2) Accept IPs"
echo "3) Toggle firewall (ON/OFF)"
read -p "Enter your choice (1/2/3): " action_choice

# Define the URLs for the selected countries
declare -A countries
for country in "${selected_countries[@]}"; do
    countries[$country]="http://www.iwik.org/ipcountry/${country}.cidr"
done

# Process actions based on user input
for country in "${selected_countries[@]}"; do
    if [[ -v countries[$country] ]]; then
        case $action_choice in
            1)
                echo "Downloading CIDR list for $country..."
                curl -o "$country.cidr" "${countries[$country]}"
                
                echo "Blocking IPs from $country..."
                while read cidr; do
                    iptables -A INPUT -s $cidr -j DROP
                done < "$country.cidr"
                ;;
            2)
                echo "Downloading CIDR list for $country..."
                curl -o "$country.cidr" "${countries[$country]}"
                
                echo "Accepting IPs from $country..."
                while read cidr; do
                    iptables -A INPUT -s $cidr -j ACCEPT
                done < "$country.cidr"
                ;;
            3)
                # Toggle firewall
                current_status=$(ufw status | grep -oP '(?<=Status: )\w+')
                if [[ "$current_status" == "active" ]]; then
                    echo "Turning off the firewall..."
                    ufw disable
                else
                    echo "Turning on the firewall..."
                    ufw enable
                fi
                ;;
            *)
                echo "Invalid choice!"
                ;;
        esac
    else
        echo "Invalid country code: $country"
    fi
done

# Save iptables rules
echo "Saving iptables rules..."
iptables-save > /etc/iptables/rules.v4

echo "Operation complete."
