# Manage IPs Script

This script allows you to block or accept IP addresses from specific countries using iptables on a Linux server. You can also toggle the firewall status (ON/OFF).

## Features

- Fetches country codes from [iwik.org](https://www.iwik.org/ipcountry/)
- Block or accept IPs from selected countries
- Toggle firewall status (enable/disable)

## Requirements

- Bash
- `curl`
- `iptables`
- `ufw` (for firewall management)

## Usage

1. **Clone the repository or download the script:**

   ```bash
   git clone https://github.com/samsesh/cn-ip-linux
   cd cn-ip-linux

Or create the script directly:

bash

nano manage_ips.sh

Paste the script content into the file and save it.

    Make the script executable:

    bash

chmod +x manage_ips.sh

Run the script with root privileges:

bash

    sudo ./manage_ips.sh

    Follow the prompts:
        Enter the 2-letter codes of the countries you want to manage (e.g., IS,CN).
        Choose an action:
            1: Block IPs
            2: Accept IPs
            3: Toggle firewall (ON/OFF)

Available Countries

The available country codes can be viewed in the terminal after running the script. They are fetched dynamically from iwik.org.
Example

To block IPs from Israel and China, you would enter IS,CN when prompted and select the action to block IPs.
Saving Rules

The script automatically saves the iptables rules, ensuring they persist after a reboot.
Important Notes

    Make sure you have proper backups of your iptables rules before running this script.
    Use caution when blocking or accepting IPs, as it can affect server accessibility.

Donate

If you find this project helpful, you can support my work by donating: Donate
License

This project is licensed under the MIT License. See the LICENSE file for details.
