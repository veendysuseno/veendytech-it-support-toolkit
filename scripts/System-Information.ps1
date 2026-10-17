[CmdletBinding()]
param([string]$ReportRoot = (Join-Path $PSScriptRoot '..\reports'))
$ErrorActionPreference = 'SilentlyContinue'
if (-not (Test-Path $ReportRoot)) { New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$file = Join-Path $ReportRoot "system-$stamp.txt"
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$bios = Get-CimInstance Win32_BIOS
$ramTotal = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
$ramFree = [math]::Round(($os.FreePhysicalMemory * 1KB) / 1GB, 2)
$disks = @(Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object {
    [pscustomobject]@{ Drive=$_.DeviceID; Label=$_.VolumeName; SizeGB=[math]::Round($_.Size/1GB,2); FreeGB=[math]::Round($_.FreeSpace/1GB,2); FreePercent=if ($_.Size) {[math]::Round($_.FreeSpace/$_.Size*100,1)} else {0} }
})
$info = [ordered]@{
    Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    ComputerName = $env:COMPUTERNAME
    LoggedInUser = "$env:USERDOMAIN\$env:USERNAME"
    Manufacturer = $cs.Manufacturer
    Model = $cs.Model
    WindowsCaption = $os.Caption
    WindowsVersion = $os.Version
    BuildNumber = $os.BuildNumber
    LastBoot = $os.LastBootUpTime
    RAMTotalGB = $ramTotal
    RAMFreeGB = $ramFree
    BIOSVersion = ($bios.SMBIOSBIOSVersion -join ', ')
}
$info.GetEnumerator() | ForEach-Object { '{0,-20}: {1}' -f $_.Key,$_.Value } | Set-Content -LiteralPath $file -Encoding UTF8
Add-Content -LiteralPath $file -Value "`n=== Fixed disks ==="
$disks | Format-Table -AutoSize | Out-String | Add-Content -LiteralPath $file
$info.GetEnumerator() | ForEach-Object { Write-Host ('{0,-20}: {1}' -f $_.Key,$_.Value) }
$disks | Format-Table -AutoSize
Write-Host "Laporan: $file" -ForegroundColor Green
Write-Host 'Periksa dan samarkan nama pengguna, hostname, dan data perangkat sebelum membagikan laporan.' -ForegroundColor Yellow
