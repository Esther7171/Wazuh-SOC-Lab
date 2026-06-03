#Requires -RunAsAdministrator
param(
    [Parameter(Mandatory=$true)]  [string]$AgentName,
    [Parameter(Mandatory=$true)]  [string]$ManagerIP,
    [Parameter(Mandatory=$true)]  [string]$AgentGroup,
    [Parameter(Mandatory=$false)] [switch]$SkipSysmon,
    [Parameter(Mandatory=$false)] [switch]$SkipPython,
    [Parameter(Mandatory=$false)] [switch]$SkipYara
)

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"
$WazuhDir  = "C:\Program Files (x86)\ossec-agent"
$LogFile   = "C:\wazuh-deploy.log"
$TempDir   = $env:TEMP

function Log {
    param([string]$Msg, [string]$Level = "INFO")
    $ts   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$ts] [$Level] $Msg"
    $col  = if ($Level -eq "ERROR") { "Red" } elseif ($Level -eq "WARN") { "Yellow" } else { "Cyan" }
    Write-Host $line -ForegroundColor $col
    Add-Content -Path $LogFile -Value $line
}

function Step { param([string]$T) Write-Host "`n$('='*60)`n  $T`n$('='*60)" -ForegroundColor Green }

function Download {
    param([string]$Url, [string]$Out)
    Log "Downloading: $Url"
    Invoke-WebRequest -Uri $Url -OutFile $Out -UseBasicParsing
}

# STEP 0 - Prepare
Step "0/9 - Preparing Environment"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DefenderWasOn = $false
try {
    $mp = Get-MpComputerStatus -ErrorAction SilentlyContinue
    if ($mp -and $mp.RealTimeProtectionEnabled) {
        Set-MpPreference -DisableRealtimeMonitoring $true
        Add-MpPreference -ExclusionPath $WazuhDir
        Add-MpPreference -ExclusionPath "C:\Sysmon"
        Add-MpPreference -ExclusionProcess "wazuh-agent.exe"
        Add-MpPreference -ExclusionProcess "sysmon64.exe"
        $DefenderWasOn = $true
        Log "Defender paused + exclusions added"
    }
} catch { Log "Defender skip: $_" "WARN" }

# STEP 1 - Install Wazuh Agent
Step "1/9 - Installing Wazuh Agent ($AgentName)"
$Msi = Join-Path $TempDir "wazuh-agent.msi"
if (Test-Path (Join-Path $WazuhDir "wazuh-agent.exe")) {
    Log "Wazuh already installed - skipping" "WARN"
} else {
    Download "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.14.5-1.msi" $Msi
    $args = "/i `"$Msi`" /q WAZUH_MANAGER=$ManagerIP WAZUH_AGENT_GROUP=$AgentGroup WAZUH_AGENT_NAME=$AgentName"
    $p = Start-Process msiexec.exe -ArgumentList $args -Wait -PassThru
    if ($p.ExitCode -ne 0) { throw "MSI failed: exit $($p.ExitCode)" }
    Remove-Item $Msi -Force -ErrorAction SilentlyContinue
    Log "Wazuh installed: $AgentName -> $ManagerIP [$AgentGroup]"
}

# STEP 2 - Configure ossec.conf
Step "2/9 - Configuring ossec.conf"
$OssecConf = Join-Path $WazuhDir "ossec.conf"
if (-not (Test-Path "$OssecConf.bak")) { Copy-Item $OssecConf "$OssecConf.bak" }

$conf = [System.IO.File]::ReadAllText($OssecConf)
$conf = $conf -replace '<disabled>yes</disabled>', '<disabled>no</disabled>'

if ($conf -notmatch 'Users\\\*\\Desktop') {
    $xo = [char]60
    $xc = [char]62
    $attrs = ' check_all="yes" whodata="yes" report_changes="yes" realtime="yes"'
    $dirsXml = @('Desktop','Downloads','Documents','Music','Pictures','Videos','OneDrive') | ForEach-Object {
        "    " + $xo + "directories" + $attrs + $xc + "C:\Users\*\$_" + $xo + "/directories" + $xc
    }
    $dirBlock = "`n" + ($dirsXml -join "`n") + "`n"
    $closeTag = $xo.ToString() + '/syscheck' + $xc.ToString()
    $conf = $conf -replace '(?s)(' + [regex]::Escape($xo.ToString() + '/syscheck' + $xc.ToString()) + ')', ($dirBlock + $closeTag)
    Log "FIM directories injected"
} else { Log "FIM directories already present" "WARN" }

if ($conf -notmatch 'DEPLOY-SCRIPT-BLOCK') {
    $CurrentUser = $env:USERNAME
    $x = [char]60  # '<'
    $X = [char]62  # '>'

    # Build each XML line as plain string — no here-string, no bare < operators
    $nl = "`r`n"
    $b  = $nl
    $b += "  " + $x + "!-- DEPLOY-SCRIPT-BLOCK --" + $X + $nl
    $b += "  " + $x + "localfile" + $X + $nl
    $b += "    " + $x + "location" + $X + "Microsoft-Windows-Windows Defender/Operational" + $x + "/location" + $X + $nl
    $b += "    " + $x + "log_format" + $X + "eventchannel" + $x + "/log_format" + $X + $nl
    $b += "  " + $x + "/localfile" + $X + $nl
    $b += "  " + $x + "localfile" + $X + $nl
    $b += "    " + $x + "location" + $X + "Microsoft-Windows-PrintService/Operational" + $x + "/location" + $X + $nl
    $b += "    " + $x + "log_format" + $X + "eventchannel" + $x + "/log_format" + $X + $nl
    $b += "  " + $x + "/localfile" + $X + $nl
    $b += "  " + $x + "localfile" + $X + $nl
    $b += "    " + $x + "location" + $X + "Microsoft-Windows-Sysmon/Operational" + $x + "/location" + $X + $nl
    $b += "    " + $x + "log_format" + $X + "eventchannel" + $x + "/log_format" + $X + $nl
    $b += "  " + $x + "/localfile" + $X + $nl
    $b += "  " + $x + "localfile" + $X + $nl
    $b += "    " + $x + "location" + $X + "Microsoft-Windows-PowerShell/Operational" + $x + "/location" + $X + $nl
    $b += "    " + $x + "log_format" + $X + "eventchannel" + $x + "/log_format" + $X + $nl
    $b += "  " + $x + "/localfile" + $X + $nl
    $b += "  " + $x + "localfile" + $X + $nl
    $b += "    " + $x + "log_format" + $X + "full_command" + $x + "/log_format" + $X + $nl
    $b += "    " + $x + "command" + $X + "C:\Users\$CurrentUser\Documents\nmapscan.exe" + $x + "/command" + $X + $nl
    $b += "    " + $x + "frequency" + $X + "604800" + $x + "/frequency" + $X + $nl
    $b += "  " + $x + "/localfile" + $X + $nl

    foreach ($tag in @(
        @{ t='CPUUsage';         q='\Processor(_Total)\% Processor Time' },
        @{ t='MEMUsage';         q='\Memory\Available MBytes' },
        @{ t='NetworkTrafficIn'; q='\Network Interface(*)\Bytes Received/sec' },
        @{ t='NetworkTrafficOut';q='\Network Interface(*)\Bytes Sent/sec' },
        @{ t='DiskFree';         q='\LogicalDisk(*)\Free Megabytes' }
    )) {
        $cmd = 'Powershell -c "@{ winCounter = (Get-Counter ''' + $tag.q + ''').CounterSamples[0] } | ConvertTo-Json -compress"'
        $b += "  " + $x + 'wodle name="command"' + $X + $nl
        $b += "    " + $x + "disabled" + $X + "no" + $x + "/disabled" + $X + $x + "tag" + $X + $tag.t + $x + "/tag" + $X + $nl
        $b += "    " + $x + "command" + $X + $cmd + $x + "/command" + $X + $nl
        $b += "    " + $x + "interval" + $X + "1m" + $x + "/interval" + $X + $x + "ignore_output" + $X + "no" + $x + "/ignore_output" + $X + $nl
        $b += "    " + $x + "run_on_start" + $X + "yes" + $x + "/run_on_start" + $X + $x + "timeout" + $X + "0" + $x + "/timeout" + $X + $nl
        $b += "  " + $x + "/wodle" + $X + $nl
    }
    $b += "  " + $x + "!-- END-DEPLOY-SCRIPT-BLOCK --" + $X + $nl

    $conf = $conf -replace '(?s)(' + $x + '/ossec_config' + $X + ')', ($b + $x + '/ossec_config' + $X)
    Log "Monitoring config appended"
} else { Log "Monitoring config already present" "WARN" }

[System.IO.File]::WriteAllText($OssecConf, $conf, [System.Text.Encoding]::UTF8)
Log "ossec.conf saved"

# STEP 3 - Sysmon
Step "3/9 - Installing Sysmon"
if ($SkipSysmon) { Log "Sysmon skipped" "WARN" }
elseif (Get-Service -Name "Sysmon64" -ErrorAction SilentlyContinue) { Log "Sysmon64 already running" "WARN" }
else {
    $SzipPath = Join-Path $TempDir "Sysmon.zip"
    $SDir     = "C:\Sysmon"
    Download "https://download.sysinternals.com/files/Sysmon.zip" $SzipPath
    Expand-Archive -Path $SzipPath -DestinationPath $SDir -Force
    Remove-Item $SzipPath -Force
    $cfg = Join-Path $SDir "sysmonconfig.xml"
    Download "https://wazuh.com/resources/blog/emulation-of-attack-techniques-and-detection-with-wazuh/sysmonconfig.xml" $cfg
    & "$SDir\sysmon64.exe" -accepteula -i $cfg | Out-Null
    Log "Sysmon64 installed"
}

# STEP 4 - PowerShell Logging
Step "4/9 - Enabling PowerShell Logging"
$sbPath  = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
$modPath = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging'
if (-not (Test-Path $sbPath))  { New-Item $sbPath  -Force | Out-Null }
if (-not (Test-Path $modPath)) { New-Item $modPath -Force | Out-Null }
Set-ItemProperty -Path $sbPath  -Name EnableScriptBlockLogging -Value 1
Set-ItemProperty -Path $modPath -Name EnableModuleLogging      -Value 1
New-ItemProperty  -Path $modPath -Name ModuleNames -PropertyType MultiString -Value @('*') -Force | Out-Null
Log "PowerShell logging enabled"

# STEP 5 - Python
Step "5/9 - Installing Python 3.13"
if ($SkipPython) { Log "Python skipped" "WARN" }
elseif (Get-Command python -ErrorAction SilentlyContinue) { Log "Python already installed" "WARN" }
else {
    $PyInst = Join-Path $TempDir "python-installer.exe"
    Download "https://www.python.org/ftp/python/3.13.5/python-3.13.5-amd64.exe" $PyInst
    $p = Start-Process $PyInst -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0 Include_doc=0" -Wait -PassThru
    Remove-Item $PyInst -Force -ErrorAction SilentlyContinue
    if ($p.ExitCode -eq 0) { Log "Python 3.13 installed" } else { Log "Python exit code: $($p.ExitCode)" "WARN" }
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    try {
        & python -m pip install --quiet --upgrade pip
        & python -m pip install --quiet valhallaAPI python-nmap
        Log "pip packages installed"
    } catch { Log "pip failed: $_" "WARN" }
}

# STEP 6 - remove-threat.exe
Step "6/9 - Installing remove-threat.exe"
$ARBin = Join-Path $WazuhDir "active-response\bin"
New-Item -ItemType Directory -Path $ARBin -Force | Out-Null
$RT = Join-Path $ARBin "remove-threat.exe"
if (-not (Test-Path $RT)) {
    Download "https://github.com/Esther7171/Wazuh/releases/download/Remove_Threat/remove-threat.exe" $RT
    Log "remove-threat.exe installed"
} else { Log "remove-threat.exe already present" "WARN" }

# STEP 7 - YARA
Step "7/9 - Installing YARA"
$YaraDir   = Join-Path $ARBin "yara"
$YaraExe   = Join-Path $YaraDir "yara64.exe"
$YaraRules = Join-Path $YaraDir "rules"

if ($SkipYara) { Log "YARA skipped" "WARN" }
elseif (Test-Path $YaraExe) { Log "YARA already installed" "WARN" }
else {
    $VCR = Join-Path $TempDir "vc_redist.x64.exe"
    Download "https://aka.ms/vs/17/release/vc_redist.x64.exe" $VCR
    Start-Process $VCR -ArgumentList "/quiet /norestart" -Wait
    Remove-Item $VCR -Force -ErrorAction SilentlyContinue
    Log "VC++ Redistributable installed"

    $YZip = Join-Path $TempDir "yara.zip"
    $YExt = Join-Path $TempDir "yara-ext"
    Download "https://github.com/VirusTotal/yara/releases/download/v4.2.3/yara-4.2.3-2029-win64.zip" $YZip
    Expand-Archive -Path $YZip -DestinationPath $YExt -Force
    Remove-Item $YZip -Force
    New-Item -ItemType Directory -Path $YaraDir   -Force | Out-Null
    New-Item -ItemType Directory -Path $YaraRules -Force | Out-Null
    Copy-Item (Join-Path $YExt "yara64.exe") $YaraExe -Force
    Remove-Item $YExt -Recurse -Force
    Log "YARA binary installed"

    $PyScript = Join-Path $YaraDir "download_yara_rules.py"
    Set-Content -Path $PyScript -Value @'
from valhallaAPI.valhalla import ValhallaAPI
v = ValhallaAPI(api_key="1111111111111111111111111111111111111111111111111111111111111111")
response = v.get_rules_text()
with open('yara_rules.yar', 'w') as fh:
    fh.write(response)
print("YARA rules downloaded.")
'@
    Push-Location $YaraDir
    try {
        & python download_yara_rules.py
        Copy-Item "yara_rules.yar" (Join-Path $YaraRules "yara_rules.yar") -Force
        Log "YARA rules downloaded"
    } catch { Log "YARA rules download failed: $_" "WARN" }
    Pop-Location

    $YaraBat = Join-Path $ARBin "yara.bat"
    $batContent = '@echo off' + "`r`n" +
        'setlocal enableDelayedExpansion' + "`r`n" +
        'reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && SET OS=32BIT || SET OS=64BIT' + "`r`n" +
        'if %OS%==32BIT (SET log_file_path="%programfiles%\ossec-agent\active-response\active-responses.log")' + "`r`n" +
        'if %OS%==64BIT (SET log_file_path="%programfiles(x86)%\ossec-agent\active-response\active-responses.log")' + "`r`n" +
        'set input=' + "`r`n" +
        'for /f "delims=" %%a in (''PowerShell -command "$logInput = Read-Host; Write-Output $logInput"'') do (set input=%%a)' + "`r`n" +
        'set json_file_path="C:\Program Files (x86)\ossec-agent\active-response\stdin.txt"' + "`r`n" +
        'echo %input% > %json_file_path%' + "`r`n" +
        'set syscheck_file_path=' + "`r`n" +
        'for /F "tokens=* USEBACKQ" %%F in (`Powershell -Nop -C "(Get-Content ''C:\Program Files (x86)\ossec-agent\active-response\stdin.txt''|ConvertFrom-Json).parameters.alert.syscheck.path"`) do (set syscheck_file_path=%%F)' + "`r`n" +
        'del /f %json_file_path%' + "`r`n" +
        'set yara_exe_path="C:\Program Files (x86)\ossec-agent\active-response\bin\yara\yara64.exe"' + "`r`n" +
        'set yara_rules_path="C:\Program Files (x86)\ossec-agent\active-response\bin\yara\rules\yara_rules.yar"' + "`r`n" +
        'echo %syscheck_file_path% >> %log_file_path%' + "`r`n" +
        'for /f "delims=" %%a in (''powershell -command "& \"%yara_exe_path%\" \"%yara_rules_path%\" \"%syscheck_file_path%\""'') do (echo wazuh-yara: INFO - Scan result: %%a >> %log_file_path%)' + "`r`n" +
        'exit /b'
    Set-Content -Path $YaraBat -Value $batContent -Encoding ASCII
    Log "yara.bat written"
}

# STEP 8 - Nmap
Step "8/9 - Installing Nmap"
$NmapExe  = "C:\Program Files (x86)\Nmap\nmap.exe"
$NmapScan = Join-Path $env:USERPROFILE "Documents\nmapscan.exe"
if (-not (Test-Path $NmapExe)) {
    $NmapInst = Join-Path $TempDir "nmap-setup.exe"
    Download "https://nmap.org/dist/nmap-7.97-setup.exe" $NmapInst
    Start-Process $NmapInst -ArgumentList "/S" -Wait
    Remove-Item $NmapInst -Force -ErrorAction SilentlyContinue
    Log "Nmap installed"
} else { Log "Nmap already present" "WARN" }

if (-not (Test-Path $NmapScan)) {
    New-Item -ItemType Directory -Path (Split-Path $NmapScan) -Force | Out-Null
    Download "https://github.com/Esther7171/Wazuh/releases/download/nmap-exe/nmapscan.exe" $NmapScan
    Log "nmapscan.exe placed in Documents"
} else { Log "nmapscan.exe already present" "WARN" }

# STEP 9 - Start Services
Step "9/9 - Starting Services"
if ($DefenderWasOn) {
    Set-MpPreference -DisableRealtimeMonitoring $false
    Log "Defender re-enabled (exclusions kept)"
}

try {
    Restart-Service -Name "Wazuh" -Force -ErrorAction Stop
    Log "Wazuh service restarted"
} catch {
    try { Start-Service -Name "Wazuh"; Log "Wazuh service started" }
    catch { net start Wazuh 2>&1 | Out-Null; Log "Wazuh started via NET START" }
}
Set-Service -Name "Wazuh" -StartupType Automatic

$status = (Get-Service -Name "Wazuh" -ErrorAction SilentlyContinue).Status
Write-Host "`n$('='*60)" -ForegroundColor Magenta
Write-Host "  DEPLOYMENT COMPLETE" -ForegroundColor Magenta
Write-Host "  Agent   : $AgentName" -ForegroundColor White
Write-Host "  Manager : $ManagerIP  |  Group: $AgentGroup" -ForegroundColor White
Write-Host "  Status  : $status" -ForegroundColor $(if ($status -eq "Running") { "Green" } else { "Red" })
Write-Host "  Log     : $LogFile" -ForegroundColor White
Write-Host "$('='*60)" -ForegroundColor Magenta
Log "Done. Wazuh service: $status"
