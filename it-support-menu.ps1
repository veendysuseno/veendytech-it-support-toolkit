# VeendyTech IT Support Automation - Safe Mode
# Windows 10/11 | PowerShell 5.1+
$ErrorActionPreference = 'Continue'
$ProjectRoot = $PSScriptRoot
$ScriptRoot = Join-Path $ProjectRoot 'scripts'
$ReportRoot = Join-Path $ProjectRoot 'reports'
if (-not (Test-Path $ReportRoot)) { New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null }

function Show-Menu {
    Clear-Host
    Write-Host '============================================' -ForegroundColor Cyan
    Write-Host ' VEENDYTECH IT SUPPORT AUTOMATION' -ForegroundColor Cyan
    Write-Host ' Safe Mode - Diagnosis and Reports Only' -ForegroundColor Yellow
    Write-Host '============================================' -ForegroundColor Cyan
    Write-Host '1. Network diagnostics'
    Write-Host '2. System information'
    Write-Host '3. Generate combined report (TXT + CSV)'
    Write-Host '4. Analyze temporary files (no deletion)'
    Write-Host '5. Printer and print queue check'
    Write-Host '6. Windows repair readiness check (no repair)'
    Write-Host '7. Open reports folder'
    Write-Host '0. Exit'
    Write-Host ''
}
function Invoke-ModuleScript([string]$FileName) {
    $path = Join-Path $ScriptRoot $FileName
    if (-not (Test-Path $path)) { Write-Host "Script tidak ditemukan: $path" -ForegroundColor Red; return }
    & $path -ReportRoot $ReportRoot
    Write-Host ''
    Read-Host 'Tekan Enter untuk kembali ke menu' | Out-Null
}
do {
    Show-Menu
    $choice = Read-Host 'Pilih menu'
    switch ($choice) {
        '1' { Invoke-ModuleScript 'Network-Diagnostics.ps1' }
        '2' { Invoke-ModuleScript 'System-Information.ps1' }
        '3' { Invoke-ModuleScript 'Generate-Report.ps1' }
        '4' { Invoke-ModuleScript 'Cleanup-Analysis.ps1' }
        '5' { Invoke-ModuleScript 'Printer-Check.ps1' }
        '6' { Invoke-ModuleScript 'Repair-Check.ps1' }
        '7' { Start-Process explorer.exe -ArgumentList $ReportRoot }
        '0' { Write-Host 'Terima kasih telah menggunakan VeendyTech Toolkit.' -ForegroundColor Green }
        default { Write-Host 'Pilihan tidak valid.' -ForegroundColor Yellow; Start-Sleep -Seconds 1 }
    }
} while ($choice -ne '0')
