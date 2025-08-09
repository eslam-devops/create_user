# Bash Script - Create Linux User

## 📌 وصف
السكريبت ده بيعمل يوزر جديد على النظام مع:
- إنشاء جروب بنفس اسم اليوزر
- تعيين وصف (Full Name)
- تعيين باسورد
- تحديد الشيل `/bin/bash`

## 🛠 المتطلبات
- صلاحيات `root` أو استخدام `sudo`
- نظام Linux فيه أوامر `useradd`, `groupadd`, `chpasswd`

## 🚀 طريقة الاستخدام
```bash
chmod +x create_user.sh
sudo ./create_user.sh

