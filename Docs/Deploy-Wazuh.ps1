#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Complete Wazuh + all components removal script.
    Removes: Wazuh Agent, Sysmon, YARA, Nmap, nmapscan, remove-threat,
             PowerShell logging registry keys, ossec.conf backup.
#>

$ProgressPreference = "SilentlyContinue"

function Log { param([string]$M,[string]$L="INFO") Write-Host "[$L] $M" -ForegroundColor $(if($L-eq"ERROR"){"Red"}elseif($L-eq"WARN"){"Yellow"}else{"Green"}) }
function Step { param([string]$T) Write-Host "`n$('='*55)`n  $T`n$('='*55)" -ForegroundColor Cyan }

# ── STOP SERVICES FIRST ─────────────────────────────────
Step "Stopping services"
foreach ($svc in @("WazuhSvc","Wazuh","Sysmon","Sysmon64")) {
    $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
    if ($s) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Log "Stopped: $svc"
    }
}

# ── UNINSTALL WAZUH AGENT (MSI) ─────────────────────────
Step "Uninstalling Wazuh Agent"
$wazuhPkg = Get-WmiObject -Class Win32_Product -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like "*Wazuh*" }
if ($wazuhPkg) {
    $wazuhPkg.Uninstall() | Out-Null
    Log "Wazuh agent uninstalled via MSI"
} else {
    # fallback — find MSI product code from registry
    $regPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    $found = $false
    foreach ($rp in $regPaths) {
        $pkg = Get-ItemProperty $rp -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -like "*Wazuh*" }
        if ($pkg) {
            $code = $pkg.PSChildName
            Start-Process msiexec.exe -ArgumentList "/x $code /q" -Wait
            Log "Wazuh uninstalled via product code: $code"
            $found = $true
            break
        }
    }
    if (-not $found) { Log "Wazuh MSI package not found" "WARN" }
}

# ── DELETE WAZUH FOLDERS ────────────────────────────────
Step "Removing Wazuh files"
foreach ($p in @(
    "C:\Program Files (x86)\ossec-agent",
    "C:\Program Files\ossec-agent",
    "C:\wazuh-deploy.log"
)) {
    if (Test-Path $p) {
        Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue
        Log "Deleted: $p"
    }
}

# ── UNINSTALL SYSMON ────────────────────────────────────
Step "Removing Sysmon"
$sysmon64 = "C:\Sysmon\sysmon64.exe"
if (Test-Path $sysmon64) {
    & $sysmon64 -u force 2>&1 | Out-Null
    Log "Sysmon64 uninstalled"
}
if (Test-Path "C:\Sysmon") {
    Remove-Item "C:\Sysmon" -Recurse -Force -ErrorAction SilentlyContinue
    Log "Deleted: C:\Sysmon"
}

# ── UNINSTALL NMAP ───────────────────────────────────────
Step "Removing Nmap"
$nmapPkg = Get-WmiObject -Class Win32_Product -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like "*Nmap*" }
if ($nmapPkg) {
    $nmapPkg.Uninstall() | Out-Null
    Log "Nmap uninstalled via MSI"
} else {
    $nmapUninstall = "C:\Program Files (x86)\Nmap\uninstall.exe"
    if (Test-Path $nmapUninstall) {
        Start-Process $nmapUninstall -ArgumentList "/S" -Wait
        Log "Nmap uninstalled"
    } else {
        Log "Nmap not found" "WARN"
    }
}
foreach ($p in @("C:\Program Files (x86)\Nmap","C:\Program Files\Nmap")) {
    if (Test-Path $p) { Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue; Log "Deleted: $p" }
}

# ── REMOVE nmapscan.exe ──────────────────────────────────
Step "Removing nmapscan.exe"
Get-ChildItem "C:\Users\*\Documents\nmapscan.exe" -ErrorAction SilentlyContinue | ForEach-Object {
    Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
    Log "Deleted: $($_.FullName)"
}

# ── REMOVE YARA ──────────────────────────────────────────
Step "Removing YARA"
foreach ($p in @(
    "C:\Program Files (x86)\ossec-agent\active-response\bin\yara",
    "C:\Program Files\ossec-agent\active-response\bin\yara"
)) {
    if (Test-Path $p) { Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue; Log "Deleted: $p" }
}

# ── REMOVE POWERSHELL LOGGING REGISTRY KEYS ─────────────
Step "Removing PowerShell logging registry keys"
foreach ($rk in @(
    'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging',
    'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging'
)) {
    if (Test-Path $rk) {
        Remove-Item $rk -Recurse -Force -ErrorAction SilentlyContinue
        Log "Removed registry: $rk"
    }
}

# ── RE-ENABLE WINDOWS DEFENDER ───────────────────────────
Step "Re-enabling Windows Defender"
try {
    Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue
    Remove-MpPreference -ExclusionPath "C:\Program Files (x86)\ossec-agent" -ErrorAction SilentlyContinue
    Remove-MpPreference -ExclusionPath "C:\Sysmon" -ErrorAction SilentlyContinue
    Remove-MpPreference -ExclusionProcess "wazuh-agent.exe" -ErrorAction SilentlyContinue
    Remove-MpPreference -ExclusionProcess "sysmon64.exe" -ErrorAction SilentlyContinue
    Log "Defender re-enabled, exclusions removed"
} catch { Log "Defender update skipped: $_" "WARN" }

# ── CLEAN TEMP ───────────────────────────────────────────
Step "Cleaning temp files"
foreach ($f in @("$env:TEMP\Deploy-Wazuh.ps1","$env:TEMP\wazuh-agent.msi")) {
    if (Test-Path $f) { Remove-Item $f -Force -ErrorAction SilentlyContinue; Log "Deleted: $f" }
}

Write-Host "`n$('='*55)" -ForegroundColor Magenta
Write-Host "  CLEANUP COMPLETE — machine is clean" -ForegroundColor Magenta
Write-Host "$('='*55)`n" -ForegroundColor Magenta
