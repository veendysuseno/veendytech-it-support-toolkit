[CmdletBinding()]
param([string]$ReportRoot = (Join-Path $PSScriptRoot '..\reports'))
$ErrorActionPreference = 'SilentlyContinue'
if (-not (Test-Path $ReportRoot)) { New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$txt = Join-Path $ReportRoot "summary-$stamp.txt"
$csv = Join-Path $ReportRoot "summary-$stamp.csv"
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$diskRows = @(Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object {
    [pscustomobject]@{ Category='Disk'; Name=$_.DeviceID; Status=if ($_.Size -gt 0 -and ($_.FreeSpace/$_.Size) -lt 0.1) {'LOW SPACE'} else {'Review'}; Details=("Free {0:N2} GB of {1:N2} GB" -f ($_.FreeSpace/1GB),($_.Size/1GB)) }
})
$rows = @(
    [pscustomobject]@{Category='System';Name='Computer';Status='INFO';Details=$env:COMPUTERNAME},
    [pscustomobject]@{Category='System';Name='Windows';Status='INFO';Details=$os.Caption},
    [pscustomobject]@{Category='System';Name='RAM';Status='INFO';Details=("{0:N2} GB" -f ($cs.TotalPhysicalMemory/1GB))}
) + $diskRows
$rows | Export-Csv -LiteralPath $csv -NoTypeInformation -Encoding UTF8
@("VeendyTech IT Support Summary", "Generated: $(Get-Date)", "Computer: $env:COMPUTERNAME", '', '=== Summary ===') | Set-Content -LiteralPath $txt -Encoding UTF8
$rows | Format-Table -AutoSize | Out-String | Add-Content -LiteralPath $txt
Write-Host "TXT report: $txt" -ForegroundColor Green
Write-Host "CSV report: $csv" -ForegroundColor Green
Write-Host 'Catatan: ini ringkasan pemeriksaan dasar, bukan audit keamanan menyeluruh.'
