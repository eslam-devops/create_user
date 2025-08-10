

1. التشيك على بورت وخدمة (ويشغلها لو مش شغالة)
2. التشيك على أن يوزر عضو في جروب (ويضيفه لو مش عضو)
3. التشيك على وجود فولدر `.ssh` وملف `authorized_keys` (ويعملهم لو مش موجودين)
4. ألوان ورسائل منظمة

---

## الكود

```bash
#!/bin/bash

# ألوان
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

echo -e "${GREEN}==== System Check Tool ====${RESET}"
echo "Select an option:"
echo "1) Check port and service"
echo "2) Check if user is in a group"
echo "3) Check SSH folder and authorized_keys"
read -p "Enter choice [1-3]: " choice

# ========== 1. تشيك البورت والسيرفيس ==========
if [ "$choice" -eq 1 ]; then
    read -p "Enter port number: " PORT
    read -p "Enter service name: " SERVICE

    if ss -tuln | grep -q ":$PORT "; then
        echo -e "${GREEN}Port $PORT is open.${RESET}"
    else
        echo -e "${RED}Port $PORT is not open.${RESET}"
        echo -e "${YELLOW}Trying to start $SERVICE service...${RESET}"
        sudo systemctl start "$SERVICE"
        if ss -tuln | grep -q ":$PORT "; then
            echo -e "${GREEN}Port $PORT is now open.${RESET}"
        else
            echo -e "${RED}Failed to open port $PORT. Please check $SERVICE service.${RESET}"
        fi
    fi
fi

# ========== 2. تشيك الجروب ==========
if [ "$choice" -eq 2 ]; then
    read -p "Enter username: " username
    read -p "Enter group name: " groupname

    if ! id "$username" &>/dev/null; then
        echo -e "${RED}The user $username does not exist.${RESET}"
        exit 1
    fi

    if ! getent group "$groupname" &>/dev/null; then
        echo -e "${RED}The group $groupname does not exist.${RESET}"
        exit 1
    fi

    if id -nG "$username" | grep -qw "$groupname"; then
        echo -e "${GREEN}The user $username is already a member of $groupname.${RESET}"
    else
        echo -e "${YELLOW}The user $username is not a member of $groupname.${RESET}"
        echo -e "${YELLOW}Adding $username to $groupname...${RESET}"
        sudo usermod -aG "$groupname" "$username"
        if id -nG "$username" | grep -qw "$groupname"; then
            echo -e "${GREEN}The user $username has been added to $groupname.${RESET}"
        else
            echo -e "${RED}Failed to add $username to $groupname.${RESET}"
        fi
    fi
fi

# ========== 3. تشيك فولدر .ssh ==========
if [ "$choice" -eq 3 ]; then
    read -p "Enter username: " username

    if ! id "$username" &>/dev/null; then
        echo -e "${RED}The user $username does not exist.${RESET}"
        exit 1
    fi

    SSH_DIR="/home/$username/.ssh"
    AUTH_FILE="$SSH_DIR/authorized_keys"

    # إنشاء الفولدر لو مش موجود
    if [ ! -d "$SSH_DIR" ]; then
        echo -e "${YELLOW}Creating .ssh folder for $username...${RESET}"
        sudo mkdir -p "$SSH_DIR"
        sudo chown "$username":"$username" "$SSH_DIR"
        sudo chmod 700 "$SSH_DIR"
    fi

    # إنشاء الملف لو مش موجود
    if [ ! -f "$AUTH_FILE" ]; then
        echo -e "${YELLOW}Creating authorized_keys file...${RESET}"
        sudo touch "$AUTH_FILE"
        sudo chown "$username":"$username" "$AUTH_FILE"
        sudo chmod 600 "$AUTH_FILE"
    fi

    echo -e "${GREEN}The user $username has a valid .ssh folder and authorized_keys file with correct permissions.${RESET}"
fi
```

---

## المميزات

* منيو واحد يجمع كل الاختيارات
* تقدر تشيك وتشغّل الخدمة والبورت
* تقدر تضيف اليوزر للجروب لو مش عضو
* تقدر تنشئ `.ssh` و `authorized_keys` بصلاحيات صحيحة
* رسائل ملونة وواضحة

---

