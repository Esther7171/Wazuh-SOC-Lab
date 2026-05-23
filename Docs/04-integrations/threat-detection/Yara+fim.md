## Configuration for Windows endpoint

### Configure Python and YARA

1. Install Python
Download the Python installer from the [official Python website](https://www.python.org/downloads/).

2. Run the Python installer once downloaded and make sure to check the following boxes:
  * Install launcher for all users
  * Add Python 3.X to PATH. This places the interpreter in the execution path.

3. Download and install the latest [Visual C++ Redistributable package](https://aka.ms/vs/17/release/vc_redist.x64.exe).

4. Open PowerShell with administrator privileges to download and extract YARA:
```
Invoke-WebRequest -Uri https://github.com/VirusTotal/yara/releases/download/v4.2.3/yara-4.2.3-2029-win64.zip -OutFile v4.2.3-2029-win64.zip
Expand-Archive v4.2.3-2029-win64.zip; Remove-Item v4.2.3-2029-win64.zip
```
5. Create a directory called ```C:\Program Files (x86)\ossec-agent\active-response\bin\yara\``` and copy the YARA executable into it:
```
mkdir 'C:\Program Files (x86)\ossec-agent\active-response\bin\yara\'
cp .\v4.2.3-2029-win64\yara64.exe 'C:\Program Files (x86)\ossec-agent\active-response\bin\yara\'
```
6. Install the valhallaAPI module:
```
pip install valhallaAPI
```
7. Copy the following script and save it as ```download_yara_rules.py```
```
notepad.exe 'C:\Program Files (x86)\ossec-agent\active-response\bin\yara\download_yara_rules.py'
```
8. Past this :
```
from valhallaAPI.valhalla import ValhallaAPI

v = ValhallaAPI(api_key="1111111111111111111111111111111111111111111111111111111111111111")
response = v.get_rules_text()

with open('yara_rules.yar', 'w') as fh:
    fh.write(response)
```
9. Run the following commands to download the rules and place them in the `C:\Program Files (x86)\ossec-agent\active-response\bin\yara\rules\` directory:
```
python.exe  'C:\Program Files (x86)\ossec-agent\active-response\bin\yara\download_yara_rules.py'
mkdir 'C:\Program Files (x86)\ossec-agent\active-response\bin\yara\rules\'
cp yara_rules.yar 'C:\Program Files (x86)\ossec-agent\active-response\bin\yara\rules\'
```
10. Configure Active Response and FIM
11. Perform the steps below to configure the Wazuh FIM and an active response script for the detection of malicious files on the endpoint.
12. Create the `yara.bat` script in the `C:\Program Files (x86)\ossec-agent\active-response\bin\` directory. This is necessary for the Wazuh-YARA Active Response scans:
```
notepad.exe 'C:\Program Files (x86)\ossec-agent\active-response\bin\yara.bat'
```
13. Past this:
```
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
14. Copy `ossec.conf` for Editing
- Open the agent configuration file located at `C:\Program Files (x86)\ossec-agent`.
- Copy `ossec.conf` to another directory, make the necessary changes, and save it back.

15. Modify `syscheck` Block
- Locate the `<syscheck>` block in the `ossec.conf` file at `C:\Program Files (x86)\ossec-agent\ossec.conf`.
- Ensure the `<disabled>` tag is set to `no`:
  
  ```xml
  <syscheck>
    <disabled>no</disabled>
  </syscheck>
    ```
16. Monitor Specific Directories
- Add the following line after the`<disabled>` tag to monitor the `/Downloads` directory. Replace `username` with the actual system user:
```
notepad.exe 'C:\Program Files (x86)\ossec-agent\ossec.conf'
```
```xml
<directories realtime="yes">C:\Users\Esther\Downloads</directories>
```
17. Restart the Wazuh agent to apply the configuration changes:
```
Restart-Service -Name wazuh
```
## Wazuh server
Perform the following steps on the Wazuh server. This allows alerting for changes in the endpoint monitored directory and configuring an active response script to trigger whenever it detects a suspicious file.

1. Add the following decoders to the Wazuh server `/var/ossec/etc/decoders/local_decoder.xml` file. This allows extracting the information from YARA scan results:
```
sudo nano /var/ossec/etc/decoders/local_decoder.xml
```
2. Past this:
```
<decoder name="yara_decoder">
    <prematch>wazuh-yara:</prematch>
</decoder>

<decoder name="yara_decoder1">
    <parent>yara_decoder</parent>
    <regex>wazuh-yara: (\S+) - Scan result: (\S+) (\S+)</regex>
    <order>log_type, yara_rule, yara_scanned_file</order>
</decoder>
```
3. Add the following rules to the Wazuh server `/var/ossec/etc/rules/local_rules.xml` file. The rules detect FIM events in the monitored directory. They also alert when malware is found by the YARA integration:
```
sudo nano /var/ossec/etc/rules/local_rules.xml
```
```
<group name="syscheck,">
  <rule id="100303" level="7">
    <if_sid>550</if_sid>
    <field name="file">C:\\Users\\<USER_NAME>\\Downloads</field>
    <description>File modified in C:\Users\<USER_NAME>\Downloads directory.</description>
  </rule>
  <rule id="100304" level="7">
    <if_sid>554</if_sid>
    <field name="file">C:\\Users\\<USER_NAME>\\Downloads</field>
    <description>File added to C:\Users\<USER_NAME>\Downloads  directory.</description>
  </rule>
</group>

<group name="yara,">
  <rule id="108000" level="0">
    <decoded_as>yara_decoder</decoded_as>
    <description>Yara grouping rule</description>
  </rule>

  <rule id="108001" level="15">
    <if_sid>108000</if_sid>
    <match>wazuh-yara: INFO - Scan result: </match>
    <description>File "$(yara_scanned_file)" is a positive match. Yara rule: $(yara_rule)</description>
  </rule>
</group>
```
4. Add the following configuration to the Wazuh server `/var/ossec/etc/ossec.conf` file:
```
sudo nano /var/ossec/etc/ossec.conf
```
```
<ossec_config>
  <command>
    <name>yara_windows</name>
    <executable>yara.bat</executable>
    <timeout_allowed>no</timeout_allowed>
  </command>

  <active-response>
    <command>yara_windows</command>
    <location>local</location>
    <rules_id>100303,100304</rules_id>
  </active-response>
</ossec_config>
```
5.  Restart the Wazuh manager to apply the configuration changes:
```
sudo systemctl restart wazuh-manager
```

## Attack emulation
1. Download a malware sample on the monitored Windows endpoint:
  * Turn off Microsoft Virus and threat protection.
  * Download the EICAR zip file:
```
Invoke-WebRequest -Uri https://secure.eicar.org/eicar_com.zip -OutFile eicar.zip
```
2. Unzip it:
```
Expand-Archive .\eicar.zip
```
3. Copy the EICAR file to the monitored directory:
```
cp .\eicar\eicar.com C:\Users\<USER_NAME>\Downloads
```
3. 
