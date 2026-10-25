# audit.ps1 - Tizim auditini o'tkazish
Start-Sleep -Seconds 10

$ScriptPath = $MyInvocation.MyCommand.Path
$UsbRoot = Split-Path -Parent $ScriptPath
$DestDir = Join-Path $UsbRoot "_Audit"

if (-not (Test-Path $DestDir)) { 
    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null 
}

$LogFile = Join-Path $DestDir "system_audit_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# 1. Tizim ma'lumotlari
Add-Content -Path $LogFile -Value "=== TIZIM MA'LUMOTLARI ==="
Add-Content -Path $LogFile -Value "Kompyuter nomi: $env:COMPUTERNAME"
Add-Content -Path $LogFile -Value "Foydalanuvchi: $env:USERNAME"
Add-Content -Path $LogFile -Value "Windows versiyasi: $((Get-CimInstance Win32_OperatingSystem).Caption)"
Add-Content -Path $LogFile -Value "Protsessor: $((Get-CimInstance Win32_Processor).Name)"
Add-Content -Path $LogFile -Value "RAM: $([math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)) GB"
Add-Content -Path $LogFile -Value "IP manzil: $((Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object {$_.InterfaceAlias -notmatch 'Loopback'}).IPAddress -join ', ')"

# 2. Wi-Fi profillari
Add-Content -Path $LogFile -Value "`n=== WI-FI PROFILLARI ==="
$profiles = netsh wlan show profiles | Select-String "All User Profile"
if ($profiles) {
    foreach ($p in $profiles) {
        $name = ($p -split ":")[1].Trim()
        Add-Content -Path $LogFile -Value "- $name"
    }
}

# 3. O'rnatilgan dasturlar
Add-Content -Path $LogFile -Value "`n=== O'RNATILGAN DASTURLAR ==="
$apps = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Select-Object DisplayName | Where-Object {$_.DisplayName}
if ($apps) {
    foreach ($app in $apps) {
        Add-Content -Path $LogFile -Value "- $($app.DisplayName)"
    }
}

Add-Content -Path $LogFile -Value "`n=== AUDIT TUGADI ==="
