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

## 2. Configuring the Wazuh Agent

Modify the Wazuh agent configuration to forward PowerShell logs to the Wazuh server for analysis.

### Step 1: Update the Configuration File
Add the following configuration to the `<ossec_config>` block of the `ossec.conf` file located at `C:\Program Files (x86)\ossec-agent`:

```ps
notepad.exe 'C:\Program Files (x86)\ossec-agent\ossec.conf'
```
```xml
<localfile>
  <location>Microsoft-Windows-PowerShell/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
```

### Step 2: Restart the Wazuh Agent
Apply the changes by restarting the Wazuh agent:

```powershell
Restart-Service -Name wazuh
```