@echo off
echo [+] USB System Audit boshlanmoqda...
echo [!] Faqat ruxsat berilgan tizimlarda foydalaning.

powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Start-Sleep -Seconds 5; & '%~dp0audit.ps1'"
