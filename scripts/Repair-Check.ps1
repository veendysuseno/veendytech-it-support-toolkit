[CmdletBinding()]
param([string]$ReportRoot = (Join-Path $PSScriptRoot '..\reports'))
$ErrorActionPreference = 'SilentlyContinue'
if (-not (Test-Path $ReportRoot)) { New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$file = Join-Path $ReportRoot "repair-check-$stamp.txt"
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('VeendyTech - Windows Repair Readiness Check (READ ONLY)')
$lines.Add("Date: $(Get-Date)")
$lines.Add('This script does NOT run DISM repair or SFC /scannow.')
$lines.Add('')
$lines.Add('=== System File Checker executable ===')
$sfc = Join-Path $env:WINDIR 'System32\sfc.exe'
$lines.Add("sfc.exe exists: $(Test-Path $sfc)")
$lines.Add('Suggested manual next step if symptoms justify it: run sfc /verifyonly from an elevated terminal. This checks files and does not repair them.')
$lines.Add('')
$lines.Add('=== DISM executable ===')
$dism = Join-Path $env:WINDIR 'System32\dism.exe'
$lines.Add("dism.exe exists: $(Test-Path $dism)")
$lines.Add('Suggested manual next step: DISM /Online /Cleanup-Image /CheckHealth. Review the command and obtain authorization first.')
$lines.Add('')
$lines.Add('=== Windows system details ===')
$os = Get-CimInstance Win32_OperatingSystem
$lines.Add("Windows: $($os.Caption)")
$lines.Add("Version: $($os.Version); Build: $($os.BuildNumber)")
$lines | Set-Content -LiteralPath $file -Encoding UTF8
$lines | ForEach-Object { Write-Host $_ }
Write-Host "Laporan: $file" -ForegroundColor Green
