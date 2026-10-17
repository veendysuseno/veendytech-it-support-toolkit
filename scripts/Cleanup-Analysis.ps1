[CmdletBinding()]
param([string]$ReportRoot = (Join-Path $PSScriptRoot '..\reports'))
$ErrorActionPreference = 'SilentlyContinue'
if (-not (Test-Path $ReportRoot)) { New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$file = Join-Path $ReportRoot "cleanup-analysis-$stamp.txt"
$tempPath = [IO.Path]::GetFullPath($env:TEMP)
$items = @(Get-ChildItem -LiteralPath $tempPath -Force)
$total = 0L
foreach ($item in $items) {
    if (-not $item.PSIsContainer) { $total += [long]$item.Length }
    else {
        $sum = (Get-ChildItem -LiteralPath $item.FullName -Recurse -Force -File | Measure-Object -Property Length -Sum).Sum
        if ($sum) { $total += [long]$sum }
    }
}
$lines = @(
    'VeendyTech - Temporary Files Analysis (READ ONLY)',
    "Date: $(Get-Date)",
    "Target: $tempPath",
    "Top-level items: $($items.Count)",
    ("Estimated total size: {0:N2} MB" -f ($total/1MB)),
    '',
    'No files were deleted or modified.',
    'Some sizes may be incomplete because files can be locked or access may be denied.'
)
$lines | Set-Content -LiteralPath $file -Encoding UTF8
$lines | ForEach-Object { Write-Host $_ }
Write-Host "Laporan: $file" -ForegroundColor Green
