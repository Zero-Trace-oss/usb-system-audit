# backup.ps1 - Foydalanuvchi ma'lumotlarini zaxiralash (faqat qo'lda ishga tushiriladi)
# Diqqat: Faqat o'z tizimingizda foydalaning!

$ScriptPath = $MyInvocation.MyCommand.Path
$UsbRoot = Split-Path -Parent $ScriptPath
$DestDir = Join-Path $UsbRoot "_Backup"

if (-not (Test-Path $DestDir)) { 
    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null 
}

$Targets = @(
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Pictures",
    "$env:USERPROFILE\Videos",
    "$env:USERPROFILE\Music"
)

foreach ($Target in $Targets) {
    if (Test-Path $Target) {
        $FolderName = Split-Path $Target -Leaf
        $DestPath = Join-Path $DestDir $FolderName
        $LogFile = Join-Path $DestDir "backup_log.txt"
        
        # Nusxalash jarayoni
        robocopy $Target $DestPath /E /Z /R:1 /W:1 /MT:8 /NP /LOG+:$LogFile /NFL /NDL /XD "$UsbRoot\_Backup"
    }
}
Write-Host "[+] Backup tugadi. Natija: $DestDir"
