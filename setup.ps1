# ============================================================
# setup.ps1 — Windows Lab Environment Setup Script
# Author: Ozcan Celik | VirtualBox Linux & Windows Practice
# ============================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " LAB SETUP — Windows Environment" -ForegroundColor Cyan
Write-Host " $(Get-Date)" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# Check OS Info
Write-Host "`n[*] System Information" -ForegroundColor Yellow
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "    OS     : $($os.Caption)"
Write-Host "    Version: $($os.Version)"
Write-Host "    Arch   : $($os.OSArchitecture)"

# Check Network Adapters
Write-Host "`n[*] Network Adapters" -ForegroundColor Yellow
Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | ForEach-Object {
    Write-Host "    [$($_.Name)] — $($_.InterfaceDescription)"
}

# Check IP Configuration
Write-Host "`n[*] IP Configuration" -ForegroundColor Yellow
Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne "127.0.0.1" } | ForEach-Object {
    Write-Host "    $($_.InterfaceAlias): $($_.IPAddress)/$($_.PrefixLength)"
}

# Check Running Services
Write-Host "`n[*] Key Security Services" -ForegroundColor Yellow
$services = @("WinDefend", "EventLog", "RemoteRegistry", "WSearch")
foreach ($svc in $services) {
    $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
    if ($s) {
        $color = if ($s.Status -eq "Running") { "Green" } else { "Red" }
        Write-Host "    $($s.DisplayName): $($s.Status)" -ForegroundColor $color
    }
}

# Check Windows Firewall
Write-Host "`n[*] Firewall Status" -ForegroundColor Yellow
$fw = Get-NetFirewallProfile
foreach ($profile in $fw) {
    $color = if ($profile.Enabled) { "Green" } else { "Red" }
    Write-Host "    $($profile.Name): $($profile.Enabled)" -ForegroundColor $color
}

Write-Host "`n[+] Setup check complete." -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
