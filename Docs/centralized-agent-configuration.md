# Logs Configure Sysmon
1. Open Powershell in Admin At default ```C:``` drive
```cmd
cd c:\
```
2. Download Sysmon
```ps1
curl https://download.sysinternals.com/files/Sysmon.zip -o Sysmon.zip
```
3. Unzip The Sysmon
```ps1
Expand-Archive Sysmon.zip
```
4. Remove Sysmon.zip becouse it no longer in use.
```ps1
rm Sysmon.zip
```
5. Go to folder.
```ps1
cd Sysmon
```
6. Install Wazuh Sysmon-config file
```ps1
curl -o sysmonconfig.xml https://wazuh.com/resources/blog/emulation-of-attack-techniques-and-detection-with-wazuh/sysmonconfig.xml
```
7. Install Config File 
```ps1
.\sysmon64.exe -accepteula -i .\sysmonconfig.xml
```

# Detecting PowerShell Exploitation Techniques in Windows Using Wazuh
Step 1: Enable PowerShell Logging

* Open Powershell as admin
```ps1
function Enable-PSLogging {
    # Define registry paths for ScriptBlockLogging and ModuleLogging
    $scriptBlockPath = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
    $moduleLoggingPath = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging'
    
    # Enable Script Block Logging
    if (-not (Test-Path $scriptBlockPath)) {
        $null = New-Item $scriptBlockPath -Force
    }
    Set-ItemProperty -Path $scriptBlockPath -Name EnableScriptBlockLogging -Value 1

    # Enable Module Logging
    if (-not (Test-Path $moduleLoggingPath)) {
        $null = New-Item $moduleLoggingPath -Force
    }
    Set-ItemProperty -Path $moduleLoggingPath -Name EnableModuleLogging -Value 1
    
    # Specify modules to log - set to all (*) for comprehensive logging
    $moduleNames = @('*')  # To specify individual modules, replace * with module names in the array
    New-ItemProperty -Path $moduleLoggingPath -Name ModuleNames -PropertyType MultiString -Value $moduleNames -Force

    Write-Output "Script Block Logging and Module Logging have been enabled."
}

Enable-PSLogging
```

> The output should be 
```
Output Script Block Logging and Module Logging have been enabled.
```

## Atomic Red Team installation
* ART Execution Framework and Atomics folder installation.
* The following command will perform the installation of the Execution Framework as well as the Atomics folder, which contains the tests and binaries that are needed for the emulation:
```ps1
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing)
Install-AtomicRedTeam -Force -getAtomics
```
* Importing the ART module
```ps1
Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force
```
2. After installation finishes, confirm the folder exists:
```ps1
ls C:\AtomicRedTeam\atomics
```
3. Then re-import the module and test again:
```ps1
Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force
Invoke-AtomicTest T1548.002 -ShowDetailsBrief
```

## Virus-Total
* Install Python, Download the Python installer from the official [Python-3.13.5](https://www.python.org/ftp/python/3.13.5/python-3.13.5-amd64.exe) website.
* Open the terminal as Administrator and install the required package:
```ps1
cd "C:\Program Files (x86)\ossec-agent\active-response\bin"
```
* Download Remove-Threat Script
```ps1
curl https://github.com/Esther7171/Wazuh/releases/download/Remove_Threat/remove-threat.exe -o remove-threat.exe
```
* Restart Agent
```ps1
Restart-Service -Name wazuh
```
## Yara Integrate 
* Download and install the latest [Visual C++ Redistributable](https://aka.ms/vs/17/release/vc_redist.x64.exe) package.
```ps1
curl https://aka.ms/vs/17/release/vc_redist.x64.exe  -o $env:USERPROFILE\Downloads\vc_redist.x64.exe
& "$env:USERPROFILE\Downloads\vc_redist.x64.exe"
```
1. Open Powershell in Admin At default ```C:``` drive
```cmd
cd c:\
```
* Open PowerShell with administrator privileges to download and extract YARA:
```ps1
Invoke-WebRequest -Uri https://github.com/VirusTotal/yara/releases/download/v4.2.3/yara-4.2.3-2029-win64.zip -OutFile v4.2.3-2029-win64.zip
Expand-Archive v4.2.3-2029-win64.zip; Remove-Item v4.2.3-2029-win64.zip
```
* Create a directory called C:\Program Files (x86)\ossec-agent\active-response\bin\yara\ and copy the YARA executable into it:
```
mkdir 'C:\Program Files (x86)\ossec-agent\active-response\bin\yara\'
cp .\v4.2.3-2029-win64\yara64.exe 'C:\Program Files (x86)\ossec-agent\active-response\bin\yara\'
```
* Install the valhallaAPI module:
```
pip install valhallaAPI
```
* Copy the following script and save it as download_yara_rules.py:
```
notepad.exe 'C:\Program Files (x86)\ossec-agent\active-response\bin\yara\download_yara_rules.py'
```
* Past this :
```py
from valhallaAPI.valhalla import ValhallaAPI

v = ValhallaAPI(api_key="1111111111111111111111111111111111111111111111111111111111111111")
response = v.get_rules_text()

with open('yara_rules.yar', 'w') as fh:
    fh.write(response)
```
* Run the following commands to download the rules and place them in the `C:\Program Files (x86)\ossec-agent\active-response\bin\yara\rules\` directory:
```
cd "C:\Program Files (x86)\ossec-agent\active-response\bin\yara"
```
* Download the rules
```
python.exe download_yara_rules.py
mkdir 'C:\Program Files (x86)\ossec-agent\active-response\bin\yara\rules\'
cp yara_rules.yar 'C:\Program Files (x86)\ossec-agent\active-response\bin\yara\rules\'
```
### Configure Active Response and FIM
* Create the yara.bat script in the `C:\Program Files (x86)\ossec-agent\active-response\bin\` directory. This is necessary for the Wazuh-YARA Active Response scans:
```
notepad.exe 'C:\Program Files (x86)\ossec-agent\active-response\bin\yara.bat'
```
* Add this:
```ps1
@echo off

setlocal enableDelayedExpansion

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && SET OS=32BIT || SET OS=64BIT


if %OS%==32BIT (
    SET log_file_path="%programfiles%\ossec-agent\active-response\active-responses.log"
)

if %OS%==64BIT (
    SET log_file_path="%programfiles(x86)%\ossec-agent\active-response\active-responses.log"
)

set input=
for /f "delims=" %%a in ('PowerShell -command "$logInput = Read-Host; Write-Output $logInput"') do (
    set input=%%a
)


set json_file_path="C:\Program Files (x86)\ossec-agent\active-response\stdin.txt"
set syscheck_file_path=
echo %input% > %json_file_path%

for /F "tokens=* USEBACKQ" %%F in (`Powershell -Nop -C "(Get-Content 'C:\Program Files (x86)\ossec-agent\active-response\stdin.txt'|ConvertFrom-Json).parameters.alert.syscheck.path"`) do (
set syscheck_file_path=%%F
)

del /f %json_file_path%
set yara_exe_path="C:\Program Files (x86)\ossec-agent\active-response\bin\yara\yara64.exe"
set yara_rules_path="C:\Program Files (x86)\ossec-agent\active-response\bin\yara\rules\yara_rules.yar"
echo %syscheck_file_path% >> %log_file_path%
for /f "delims=" %%a in ('powershell -command "& \"%yara_exe_path%\" \"%yara_rules_path%\" \"%syscheck_file_path%\""') do (
    echo wazuh-yara: INFO - Scan result: %%a >> %log_file_path%
)

exit /b
```
# ChatGpt For Port Scan
* [Nmap v7.97](https://nmap.org/dist/nmap-7.97-setup.exe) or later. Ensure to add Nmap to PATH.
```
curl https://nmap.org/dist/nmap-7.97-setup.exe  -o $env:USERPROFILE\Downloads\nmap.exe
& "$env:USERPROFILE\Downloads\nmap.exe"
```
* Run the command below to install the python-nmap library and all its dependencies using Powershell:
```
pip3 install python-nmap
```
* Open powershell as admin and Go To `Documents` and download a file nmap `nmapscan.exe`
```
curl https://github.com/Esther7171/Wazuh/releases/download/nmap-exe/nmapscan.exe -o $env:USERPROFILE\Documents\nmapscan.exe
```
* The Nmapscan.exe executable is download under `C:\Users<USERNAME>\Documents` directory.
* Open the agent configuration file located at `C:\Program Files (x86)\ossec-agent`.
```
notepad.exe 'C:\Program Files (x86)\ossec-agent\ossec.conf'
```
* Go to bottom of file Under `<ossec_config>` block.
```xml
<!-- Run nmap python script -->
  <localfile>
    <log_format>full_command</log_format>
    <command>C:\Users\<Add UserName Here>\Documents\nmapscan.exe</command>
    <frequency>604800</frequency>
  </localfile>
```
## Configure Agent for FIM + Virus Total + Yara
* Open the agent configuration file located at `C:\Program Files (x86)\ossec-agent`.
```
notepad.exe 'C:\Program Files (x86)\ossec-agent\ossec.conf'
```
* Modify `syscheck` Block
* Locate the `<syscheck>` block in the `ossec.conf` file at `C:\Program Files (x86)\ossec-agent\ossec.conf`.
* Ensure the `<disabled>` tag is set to `no`:
```xml
<syscheck>
  <disabled>no</disabled>
</syscheck>
```
* Monitor Directories
```
<directories check_all="yes" whodata="yes" report_changes="yes" realtime="yes">C:\Users\*\Desktop</directories>
<directories check_all="yes" whodata="yes" report_changes="yes" realtime="yes">C:\Users\*\Downloads</directories>
<directories check_all="yes" whodata="yes" report_changes="yes" realtime="yes">C:\Users\*\Documents</directories>
<directories check_all="yes" whodata="yes" report_changes="yes" realtime="yes">C:\Users\*\Music</directories>
<directories check_all="yes" whodata="yes" report_changes="yes" realtime="yes">C:\Users\*\Pictures</directories>
<directories check_all="yes" whodata="yes" report_changes="yes" realtime="yes">C:\Users\*\Videos</directories>
<directories check_all="yes" whodata="yes" report_changes="yes" realtime="yes">C:\Users\*\OneDrive</directories>
```
* Add at bottom of file to monitor
* [ ] Windows Defender
* [ ] Printer Service
* [ ] Sysmon
* [ ] PowerShell
* [ ] CPU Usage
* [ ] Memory Usage
* [ ] Network Received
* [ ] Network Sent
* [ ] Disk Free

```xml
<localfile>
  <location>Microsoft-Windows-Windows Defender/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>

<localfile>
  <location>Microsoft-Windows-PrintService/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>

<localfile>
    <location>Microsoft-Windows-Sysmon/Operational</location>
    <log_format>eventchannel</log_format>
</localfile>

<localfile>
  <location>Microsoft-Windows-PowerShell/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>

<!-- CPU Usage -->
    <wodle name="command">
        <disabled>no</disabled>
        <tag>CPUUsage</tag>
        <command>Powershell -c "@{ winCounter = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples[0] } | ConvertTo-Json -compress"</command>
        <interval>1m</interval>
        <ignore_output>no</ignore_output>
        <run_on_start>yes</run_on_start>
        <timeout>0</timeout>
    </wodle>
<!-- Memory Usage -->
    <wodle name="command">
        <disabled>no</disabled>
        <tag>MEMUsage</tag>
        <command>Powershell -c "@{ winCounter = (Get-Counter '\Memory\Available MBytes').CounterSamples[0] } | ConvertTo-Json -compress"</command>
        <interval>1m</interval>
        <ignore_output>no</ignore_output>
        <run_on_start>yes</run_on_start>
        <timeout>0</timeout>
    </wodle>
<!-- Network Received -->
    <wodle name="command">
        <disabled>no</disabled>
        <tag>NetworkTrafficIn</tag>
        <command>Powershell -c "@{ winCounter = (Get-Counter '\Network Interface(*)\Bytes Received/sec').CounterSamples[0] } | ConvertTo-Json -compress"</command>
        <interval>1m</interval>
        <ignore_output>no</ignore_output>
        <run_on_start>yes</run_on_start>
        <timeout>0</timeout>
    </wodle>
<!-- Network Sent -->
    <wodle name="command">
        <disabled>no</disabled>
        <tag>NetworkTrafficOut</tag>
        <command>Powershell -c "@{ winCounter = (Get-Counter '\Network Interface(*)\Bytes Sent/sec').CounterSamples[0] } | ConvertTo-Json -compress"</command>
        <interval>1m</interval>
        <ignore_output>no</ignore_output>
        <run_on_start>yes</run_on_start>
        <timeout>0</timeout>
    </wodle>
<!-- Disk Free -->
    <wodle name="command">
        <disabled>no</disabled>
        <tag>DiskFree</tag>
        <command>Powershell -c "@{ winCounter = (Get-Counter '\LogicalDisk(*)\Free Megabytes').CounterSamples[0] } | ConvertTo-Json -compress"</command>
        <interval>1m</interval>
        <ignore_output>no</ignore_output>
        <run_on_start>yes</run_on_start>
        <timeout>0</timeout>
    </wodle>
```
* Restart Agent
```ps1
Restart-Service -Name wazuh
```
