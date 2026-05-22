# Sysmon + Wazuh for log collection
Configure Wazuh With Sysmon So we See Incidents More Clearly

1. Open Powershell in Admin At default ```C:``` drive
```
cd c:\
```
2. Download Sysmon
```
curl https://download.sysinternals.com/files/Sysmon.zip -o Sysmon.zip
```
3. Unzip The Sysmon
```ps
Expand-Archive Sysmon.zip
```
4. Remove Sysmon.zip becouse it no longer in use.
```ps
rm Sysmon.zip
```
5. Go to folder.
```
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

Sysmon installation and configuration
In order to modify the Sysmon default configuration, which is needed for the purpose of this article, it is necessary to create an XML file. Below you can see an XML configuration that would work for Sysmon to generate the right log when Powershell is executed:

Open Powershell as admin
```
notepad.exe 'C:\Program Files (x86)\ossec-agent\ossec.conf'
```
Agent ```Ossec.conf``` add 
```xml

<localfile>
  <location>Microsoft-Windows-PrintService/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
<localfile>
    <location>Microsoft-Windows-Sysmon/Operational</location>
    <log_format>eventchannel</log_format>
</localfile>
```

<div align="center">
<img src="https://github.com/user-attachments/assets/54c7a1e4-dec1-4da7-a101-0cd0042ce711"></img>
</div>
<!--    
### **1️⃣ Modify Sysmon Configuration**
Use the [SwiftOnSecurity Sysmon config](https://github.com/SwiftOnSecurity/sysmon-config) or create your own.
Download:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml" -OutFile "sysmon-config.xml"
```
Modify the configuration:
- Add USB-related process monitoring (`rundll32.exe`, `powershell.exe`, `cmd.exe`, etc.):
  ```xml
  <ProcessCreate onmatch="include">
    <Image condition="contains">rundll32.exe</Image>
    <Image condition="contains">powershell.exe</Image>
    <Image condition="contains">cmd.exe</Image>
    <Image condition="contains">printui.exe</Image>
  </ProcessCreate>
  ```
- Enable Event ID `3` for USB network activity tracking:
  ```xml
  <NetworkConnect onmatch="include">
    <Image condition="contains">explorer.exe</Image>
  </NetworkConnect>
  ```
### **2️⃣ Apply Sysmon Configuration**
```powershell
.\sysmon64.exe -c sysmon-config.xml
```
---
## **📌 Step 2: Enable Windows Event Logs for USB & Printer Detection**  
Sysmon does not log USB insertions directly, so we need Windows Event IDs:
- **USB Insertions** → `Event ID 6416` (Audit PNP Device)
- **USB Removals** → `Event ID 2003` (Kernel-PNP)
- **Printer Usage** → `Event ID 307` (PrintService Operational)
### **1️⃣ Enable USB Logging**
Run the following PowerShell commands:
```powershell
auditpol /set /subcategory:"Plug and Play Events" /success:enable /failure:enable
```
### **2️⃣ Enable Printer Logs**
1. Open **Event Viewer** (`eventvwr.msc`).
2. Navigate to:
   ```
   Applications and Services Logs > Microsoft > Windows > PrintService
   ```
3. Right-click **Operational** and select **Enable Log**.
---

## **📌 Optional: Configure Wazuh to Collect USB & Printer Logs**  

### **1️⃣ Edit `ossec.conf` on Wazuh Agent**
Modify **Wazuh Agent Configuration** (`C:\Program Files (x86)\ossec-agent\ossec.conf`) and add:

```xml
<localfile>
  <log_format>eventchannel</log_format>
  <location>Microsoft-Windows-Kernel-PnP/Device Management</location>
</localfile>
```

Restart Wazuh Agent:
```powershell
Restart-Service WazuhSvc
```

---

## **📌 Optional: Add Wazuh Rules for USB & Printer Events**
Edit **Wazuh Rules** on the **Wazuh Manager** (`/var/ossec/ruleset/rules/local_rules.xml`):

### **1️⃣ USB Detection Rules**
```xml
<group name="windows,usb,">
  <rule id="100010" level="7">
    <decoded_as>json</decoded_as>
    <field name="win.system">Microsoft-Windows-Kernel-PnP</field>
    <field name="win.eventdata.DeviceClass">USB</field>
    <description>USB device connected</description>
  </rule>
  
  <rule id="100011" level="7">
    <decoded_as>json</decoded_as>
    <field name="win.system">Microsoft-Windows-Kernel-PnP</field>
    <field name="win.eventdata.DeviceClass">USB</field>
    <description>USB device removed</description>
  </rule>
</group>
```

### **2️⃣ Printer Usage Rules**
```xml
<group name="windows,printer,">
  <rule id="100020" level="5">
    <decoded_as>json</decoded_as>
    <field name="win.system">Microsoft-Windows-PrintService</field>
    <field name="win.eventdata.Param1">Document Printed</field>
    <description>Printer activity detected</description>
  </rule>
</group>
```
```
https://wazuh.com/blog/learn-to-detect-threats-on-windows-by-monitoring-sysmon-events/
```
```
https://wazuh.com/blog/using-wazuh-to-monitor-sysmon-events/
```

---

## Wazuh Server Config To get All Logs

### Enabling archiving

Edit the Wazuh manager configuration file `/var/ossec/etc/ossec.conf` and set the value of the highlighted fields below to yes:
```xml
<ossec_config>
  <global>
    <jsonout_output>yes</jsonout_output>
    <alerts_log>yes</alerts_log>
    <logall>yes</logall>
    <logall_json>yes</logall_json>
   ...
</ossec_config>
```

> Where:
>
> `<logall>` enables or disables archiving of all log messages. When enabled, the Wazuh server stores the logs in a syslog format. The allowed values are yes and no.
>
> `<logall_json>` enables or disables logging of events. When enabled, the Wazuh server stores the events in a JSON format. The allowed values are yes and no.
>
> Depending on the format you desire, you can set one or both values of the highlighted fields to `yes`. However, only the `<logall_json>yes</logall_json>` option allows you to create an index that can be used to visualize the events on the Wazuh dashboard.

Restart the Wazuh manager to apply the configuration changes:
```
systemctl restart wazuh-manager
```
Depending on your chosen format, the file archives.log, archives.json, or both will be created in the /var/ossec/logs/archives/ directory on the Wazuh server.

Wazuh uses a default log rotation policy. It ensures that available disk space is conserved by rotating and compressing logs on a daily, monthly, and yearly basis.
Visualizing the events on the dashboard

Edit the Filebeat configuration file `/etc/filebeat/filebeat.yml` and change the value of archives: enabled from `false` to `true`:
```
archives:
 enabled: true
```
Restart Filebeat to apply the configuration changes:
```
systemctl restart filebeat
```

## Wazuh dashboard

1. Click the upper-left menu icon to open the main menu. Expand Dashboard management and navigate to `Dashboards management` > `Index patterns`. Next, click Create index pattern. Use `wazuh-archives-`* as the index pattern name, and set `timestamp` in the Time field drop-down list.
```
wazuh-archives-`
```

The GIF below shows how to create the index pattern.

![creating-wazuh-archives-index-pattern1](https://github.com/user-attachments/assets/4e973d09-c7bb-4e43-9d68-20cfba91d204)

2. To view the events on the dashboard, click the upper-left menu icon and navigate to Discover. Change the index pattern to wazuh-archives-*.

![view-events-on-dashboard1](https://github.com/user-attachments/assets/2be05096-c428-4e1b-b318-a00848e2fcd5)
