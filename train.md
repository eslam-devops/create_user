تمام هكتب لك الكود بعد التصليح كامل وبعدين أشرح لك كل الـ options اللي فيه وكل السيناريوهات اللي هيشتغل عليها

---

## **الكود المصحح**

```bash
#!/bin/bash

# Colors
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# Read input
read -p "Enter group name: " group
read -p "Enter user shell (e.g. /bin/bash): " usershell
read -p "Enter username: " username

# 1. Check if username is empty
if [ -z "$username" ]; then
    echo -e "${RED}The username can't be empty.${RESET}"
    exit 1
fi

# 2. Check if user already exists
if id "$username" &>/dev/null; then
    echo -e "${RED}The username '$username' already exists.${RESET}"
    exit 1
fi

# 3. Check if group exists, if not create it
if ! getent group "$group" &>/dev/null; then
    echo -e "${YELLOW}Group '$group' does not exist. Creating it...${RESET}"
    if sudo groupadd "$group"; then
        echo -e "${GREEN}Group '$group' created successfully.${RESET}"
    else
        echo -e "${RED}Failed to create group '$group'.${RESET}"
        exit 1
    fi
fi

# 4. Create user
if sudo useradd -m -c "$username" -g "$group" -s "$usershell" "$username"; then
    echo -e "${GREEN}User '$username' created successfully.${RESET}"
else
    echo -e "${RED}Failed to create user '$username'.${RESET}"
    exit 1
fi
```

---

## **الـ Options المستخدمة**

1. **`-m`**

   * ينشئ فولدر الـ home لليوزر تلقائيًا لو مش موجود

2. **`-c "$username"`**

   * بيضيف الـ comment أو الوصف في `/etc/passwd` (هنا بنحط اسم اليوزر نفسه)

3. **`-g "$group"`**

   * بيحدد الجروب الأساسي لليوزر

4. **`-s "$usershell"`**

   * بيحدد الـ shell الافتراضي لليوزر (مثلا `/bin/bash` أو `/bin/sh`)

---

## **السيناريوهات**

1. **يوزر فاضي**

   * لو ما كتبتش اسم يوزر → يطبع رسالة خطأ ويخرج

2. **يوزر موجود بالفعل**

   * لو الـ username موجود → يطبع رسالة خطأ ويخرج

3. **الجروب مش موجود**

   * السكريبت هيعمله تلقائي ويكمل

4. **الجروب موجود**

   * السكريبت هيكمل مباشرة لإنشاء اليوزر

5. **إنشاء اليوزر ناجح**

   * يطبع رسالة نجاح باللون الأخضر

6. **إنشاء اليوزر فشل**

   * يطبع رسالة خطأ ويخرج

---

========================================================================================================================================

تمام فهمت انت عايز تضيف **for loop** بحيث تنفذ نفس التشيك والإنشاء لأكتر من يوزر أو جروب مرة واحدة

هظبطلك الكود اللي فوق عشان يقبل **قائمة يوزرات** وتعملهم نفس الخطوات

---

## الكود بـ for

```bash
#!/bin/bash

# Colors
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# Read input
read -p "Enter group name: " group
read -p "Enter user shell (e.g. /bin/bash): " usershell
read -p "Enter usernames (space separated): " usernames

# 1. Check if group exists, if not create it
if ! getent group "$group" &>/dev/null; then
    echo -e "${YELLOW}Group '$group' does not exist. Creating it...${RESET}"
    if sudo groupadd "$group"; then
        echo -e "${GREEN}Group '$group' created successfully.${RESET}"
    else
        echo -e "${RED}Failed to create group '$group'.${RESET}"
        exit 1
    fi
fi

# 2. Loop for each username
for username in $usernames; do
    # Check if username is empty
    if [ -z "$username" ]; then
        echo -e "${RED}Username can't be empty. Skipping...${RESET}"
        continue
    fi

    # Check if user exists
    if id "$username" &>/dev/null; then
        echo -e "${RED}User '$username' already exists. Skipping...${RESET}"
        continue
    fi

    # Create the user
    if sudo useradd -m -c "$username" -g "$group" -s "$usershell" "$username"; then
        echo -e "${GREEN}User '$username' created successfully in group '$group'.${RESET}"
    else
        echo -e "${RED}Failed to create user '$username'.${RESET}"
    fi
done
```

---

### الفكرة:

* بتكتب الجروب والشل مرة واحدة
* بتكتب كل أسماء اليوزرات مفصولة بمسافات
* الـ `for` هيمر على كل اسم ويعمل نفس التشكيك والإنشاء

---

لو عايز ممكن أعملها كمان بحيث كل يوزر ياخد باسورد تلقائي ويتكتب في ملف عشان تعرفه بعدين.
تحب أظبطه بالطريقة دي؟

