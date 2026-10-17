[CmdletBinding()]
param([string]$ReportRoot = (Join-Path $PSScriptRoot '..\reports'))
$ErrorActionPreference = 'SilentlyContinue'
if (-not (Test-Path $ReportRoot)) { New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$file = Join-Path $ReportRoot "network-$stamp.txt"
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('VeendyTech - Network Diagnostics')
$lines.Add("Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$lines.Add("Computer: $env:COMPUTERNAME")
$lines.Add('')
$lines.Add('=== IP Configuration ===')
$lines.AddRange([string[]](ipconfig /all 2>&1 | ForEach-Object { "$_" }))
$lines.Add('')
$lines.Add('=== Default Gateway ===')
$routes = @(Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Sort-Object RouteMetric)
if ($routes.Count -eq 0) { $lines.Add('No IPv4 default route found.') }
foreach ($route in $routes) {
    $gw = $route.NextHop
    $lines.Add("Gateway: $gw")
    $ping = Test-Connection -ComputerName $gw -Count 2 -ErrorAction SilentlyContinue
    if ($ping) { $lines.Add("Gateway ping: SUCCESS ($($ping.Count) replies)") } else { $lines.Add('Gateway ping: no reply (ICMP may be blocked).') }
}
$lines.Add('')
$lines.Add('=== Internet reachability test: 1.1.1.1 ===')
$internet = Test-Connection -ComputerName '1.1.1.1' -Count 2 -ErrorAction SilentlyContinue
$lines.Add($(if ($internet) { 'Ping returned a reply.' } else { 'No ping reply; ICMP may be blocked or connectivity unavailable.' }))
$lines.Add('')
$lines.Add('=== DNS lookup: example.com ===')
$dns = Resolve-DnsName 'example.com' -ErrorAction SilentlyContinue
if ($dns) { $lines.AddRange([string[]]($dns | Select-Object Name, Type, IPAddress | Format-Table -AutoSize | Out-String -Stream)) } else { $lines.Add('DNS lookup failed or DNS cmdlet unavailable.') }
$lines | Set-Content -LiteralPath $file -Encoding UTF8
$lines | ForEach-Object { Write-Host $_ }
Write-Host "`nLaporan: $file" -ForegroundColor Green
