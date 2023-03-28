<#
 
  Version:           1.4
  Author:            Richard ~ TapRoot Consulting Ltd
  Creation Date:     08-Jan-2023
  Modification Date: 11-Feb-2023 
  
  This script facilitates backing up all files and folders in $source to $destination
  It will then dispose of old backups by checking there are only 5x folders in backup destination
  It will log results. Set this script as a scheduled task, weekly, daily etc. 
  
  Lines 16, 17, 24 and optionally 18 (to set number of backups to keep) will need editing before use. 
#>


$source = "C:\PATH\OF\FILES\TO\BACKUP"
$destination = "D:\PATH\OF\WHERE\TO\BACKUP\TO"
$maxBackups = 5

$date = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
$backupName = "Full-Fileshare-Backup-$date"
$backupPath = Join-Path $destination $backupName

Start-Transcript -Append D:\PATH\TO\LOG.txt
Write-Output "Backing up $source to $backupPath..."

if (!(Test-Path $destination)) {
  Write-Output "Creating destination directory $destination..."
  New-Item $destination -ItemType Directory | Out-Null
}

Copy-Item $source $backupPath -Recurse

Write-Output "Checking for old backups to delete..."

$backups = Get-ChildItem $destination | Where-Object { $_.PSIsContainer } | Sort-Object LastWriteTime -Descending

for ($i = $maxBackups; $i -lt $backups.Count; $i++) {
  Write-Output "Deleting old backup: $($backups[$i].FullName)..."
  Remove-Item $($backups[$i].FullName) -Recurse -Force
}

Write-Output "Backup complete."
Stop-Transcript
