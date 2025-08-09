#!/bin/bash

#---------------------------
# User Creation Script
# Author: Eslam Zain
# Description: Create a new Linux user with full details
#---------------------------

# Colors
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

echo -e "${YELLOW}👤 User Creation Tool${RESET}"

# Ask for username
read -p "Enter username: " username
if [ -z "$username" ]; then
    echo -e "${RED}❌ Username cannot be empty${RESET}"
    exit 1
fi

# Ask for full name
read -p "Enter full name (Description): " fullname

# Ask for group
read -p "Enter primary group (leave empty to use username): " groupname
if [ -z "$groupname" ]; then
    groupname="$username"
fi

# Ask for shell
read -p "Enter shell (default: /bin/bash): " usershell
if [ -z "$usershell" ]; then
    usershell="/bin/bash"
fi

# Ask for password
read -s -p "Enter password: " password
echo
if [ -z "$password" ]; then
    echo -e "${RED}❌ Password cannot be empty${RESET}"
    exit 1
fi

# Create group if not exists
if getent group "$groupname" > /dev/null; then
    echo -e "${GREEN}✅ Group '$groupname' already exists${RESET}"
else
    if sudo groupadd "$groupname"; then
        echo -e "${GREEN}✅ Group '$groupname' created successfully${RESET}"
    else
        echo -e "${RED}❌ Failed to create group '$groupname'${RESET}"
        exit 1
    fi
fi

# Create user
if id "$username" &>/dev/null; then
    echo -e "${RED}❌ User '$username' already exists${RESET}"
    exit 1
else
    if sudo useradd -m -c "$fullname" -g "$groupname" -s "$usershell" "$username"; then
        echo -e "${GREEN}✅ User '$username' created successfully${RESET}"
    else
        echo -e "${RED}❌ Failed to create user${RESET}"
        exit 1
    fi
fi

# Set password
echo "$username:$password" | sudo chpasswd
if [ $? -eq 0 ]; then
    echo -e "${GREEN}🔑 Password set successfully${RESET}"
else
    echo -e "${RED}❌ Failed to set password${RESET}"
    exit 1
fi

# Final message
echo -e "${GREEN}🎯 User '$username' has been created with group '$groupname' and shell '$usershell'${RESET}"

