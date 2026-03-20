# ============================================================
# user_mgmt.ps1 — Local User & Group Management Script
# Author: Ozcan Celik | VirtualBox Linux & Windows Practice
# ============================================================

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("list","create","delete","info")]
    [string]$Action = "list",
    [string]$Username = ""
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " USER MANAGEMENT SCRIPT" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

switch ($Action) {

    "list" {
        Write-Host "`n[*] Local Users:" -ForegroundColor Yellow
        Get-LocalUser | ForEach-Object {
            $status = if ($_.Enabled) { "[ACTIVE]" } else { "[DISABLED]" }
            $color = if ($_.Enabled) { "Green" } else { "Red" }
            Write-Host "    $status $($_.Name)" -ForegroundColor $color
        }

        Write-Host "`n[*] Local Groups:" -ForegroundColor Yellow
        Get-LocalGroup | ForEach-Object {
            Write-Host "    - $($_.Name)"
        }
    }

    "info" {
        if (-not $Username) { Write-Host "[!] Provide -Username"; exit }
        $user = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue
        if ($user) {
            Write-Host "`n[*] User Info: $Username" -ForegroundColor Yellow
            Write-Host "    Enabled        : $($user.Enabled)"
            Write-Host "    Last Logon     : $($user.LastLogon)"
            Write-Host "    Password Set   : $($user.PasswordLastSet)"
            Write-Host "    Account Expires: $($user.AccountExpires)"
            Write-Host "`n[*] Group Memberships:" -ForegroundColor Yellow
            Get-LocalGroup | ForEach-Object {
                $members = Get-LocalGroupMember $_ -ErrorAction SilentlyContinue
                if ($members.Name -like "*$Username*") {
                    Write-Host "    - $($_.Name)"
                }
            }
        } else {
            Write-Host "[!] User '$Username' not found."
        }
    }

    "create" {
        if (-not $Username) { Write-Host "[!] Provide -Username"; exit }
        $password = Read-Host "Enter password for $Username" -AsSecureString
        New-LocalUser -Name $Username -Password $password -FullName $Username -Description "Lab user"
        Write-Host "[+] User '$Username' created." -ForegroundColor Green
    }

    "delete" {
        if (-not $Username) { Write-Host "[!] Provide -Username"; exit }
        Remove-LocalUser -Name $Username -ErrorAction SilentlyContinue
        Write-Host "[+] User '$Username' deleted." -ForegroundColor Green
    }
}

Write-Host "`n============================================" -ForegroundColor Cyan
