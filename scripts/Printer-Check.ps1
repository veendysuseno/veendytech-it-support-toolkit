[CmdletBinding()]
param([string]$ReportRoot = (Join-Path $PSScriptRoot '..\reports'))
$ErrorActionPreference = 'SilentlyContinue'
if (-not (Test-Path $ReportRoot)) { New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$file = Join-Path $ReportRoot "printer-$stamp.txt"
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('VeendyTech - Printer Check (READ ONLY)')
$lines.Add("Date: $(Get-Date)")
try {
    $printers = @(Get-Printer -ErrorAction Stop)
    if ($printers.Count -eq 0) { $lines.Add('No installed printers found.') }
    foreach ($p in $printers) {
        $lines.Add("Printer: $($p.Name) | Status: $($p.PrinterStatus) | Shared: $($p.Shared) | Port: $($p.PortName) | Driver: $($p.DriverName)")
        $jobs = @(Get-PrintJob -PrinterName $p.Name -ErrorAction SilentlyContinue)
        $lines.Add("  Queue jobs: $($jobs.Count)")
        foreach ($job in $jobs) { $lines.Add("  Job ID $($job.ID): $($job.DocumentName) | Status: $($job.JobStatus)") }
    }
} catch { $lines.Add("Printer query unavailable: $($_.Exception.Message)"); $lines.Add('Try a supported Windows PowerShell session. No printer settings were changed.') }
$lines | Set-Content -LiteralPath $file -Encoding UTF8
$lines | ForEach-Object { Write-Host $_ }
Write-Host "Laporan: $file" -ForegroundColor Green
