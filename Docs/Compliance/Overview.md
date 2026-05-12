

# Windows 10
| **Setting**                                                                 | **Status**                                                              |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------|
| Length of password                                                           | 8>=24 char [English uppercase characters (A through Z) - English lowercase characters (a through z) - Base 10 digits (0 through 9) - Non-alphabetic characters (for example, !, $, #, %) o A catch-all category of any Unicode character] |
| Maximum password age                                                         | 60 days                                                                  |
| Minimum password age                                                         | 7 days                                                                   |
| Account lockout duration                                                     | 15 or more minutes                                                       |
| Account lockout threshold                                                    | 5 or fewer invalid logon attempt(s), but not 0                            |
| Reset account lockout counter after                                          | 15 or more minute(s)                                                     |
| Accounts: Administrator account status                                       | Disabled                                                                 |
| Accounts: Block Microsoft accounts                                           | Users can't add or log on with Microsoft accounts                        |
| Accounts: Guest account status                                               | Disabled                                                                 |
| Accounts: Limit local account use of blank passwords to console logon only   | Enabled                                                                  |
| Accounts: Rename administrator account                                       |                                                                         |
| Audit: Force audit policy subcategory settings                               | Enabled                                                                  |
| Audit: Shut down system immediately if unable to log security audits        | Disabled                                                                 |
| Devices: Allowed to format and eject removable media                         | Administrators and Interactive Users                                      |
| Devices: Prevent users from installing printer drivers                       | Enabled                                                                  |
| Domain member: Digitally encrypt or sign secure channel data                | Enabled                                                                  |
| Interactive logon: Don't display last signed-in                              | Enabled                                                                  |
| Interactive logon: Machine account lockout threshold                         | 10 or fewer invalid logon attempts, but not 0                             |
| Interactive logon: Machine inactivity limit                                  | 900 or fewer second(s), but not 0                                        |
| Interactive logon: Message text for users attempting to log on              |                                                                         |
| Interactive logon: Prompt user to change password before expiration          | between 5 and 14 days                                                    |
| Interactive logon: Smart card removal behavior                               | Lock Workstation or higher                                              |
| Microsoft network client: Digitally sign communications                      | Enabled                                                                  |
| Microsoft network client: Digitally sign communications (if server agrees)  | Enabled                                                                  |
| Microsoft network client: Send unencrypted password to third-party SMB servers | Disabled                                                             |
| Microsoft network server: Server SPN target name validation level           | Accept if provided by client                                              |
| Network access: Allow anonymous SID/Name translation                         | Disabled                                                                 |
| Network access: Do not allow anonymous enumeration of SAM accounts and shares | Enabled                                                             |
| Network access: Do not allow storage of passwords and credentials for network authentication | Enabled                               |
| Network access: Let Everyone permissions apply to anonymous users           | Disabled                                                                 |
| Network access: Named Pipes that can be accessed anonymously                | None                                                                     |
| Configure use of hardware-based encryption for removable data drives        | Enabled                                                                  |
| Configure use of hardware-based encryption for removable data drives: Use BitLocker software-based encryption when hardware encryption is not available | Enabled: True                        |
| Configure use of hardware-based encryption for removable data drives: Restrict encryption algorithms and cipher suites allowed for hardware-based encryption | Enabled: False                      |
| Configure use of hardware-based encryption for removable data drives: Restrict crypto algorithms or cipher suites to the following | Enabled: 2.16.840.1.101.3.4.1.2;2.16.840.1.101.3.4.1.42   |
| Configure use of passwords for removable data drives                        | Disabled                                                                 |
| Configure use of smart cards on removable data drives                       | Enabled                                                                  |
| Configure use of smart cards on removable data drives: Require use of smart cards on removable data drives | Enabled: True          |
| Deny write access to removable drives not protected by BitLocker            | Enabled                                                                  |
| Deny write access to removable drives not protected by BitLocker: Do not allow write access to devices configured in another organization | Enabled: False            |
| Choose drive encryption method and cipher strength (Windows 10 [Version 1511] and later) | Enabled: XTS-AES 256-bit                |
| Turn off Microsoft consumer experiences                                     | Enabled                                                                  |
| Do not display the password reveal button                                   | Enabled                                                                  |
| Enumerate administrator accounts on elevation                               | Disabled                                                                 |
| Allow Telemetry                                                              | Enabled: 0 - Security [Enterprise Only]                                   |
| Disable pre-release features or settings                                    | Disabled                                                                 |
| Do not show feedback notifications                                          | Enabled                                                                  |
| Toggle user control over Insider builds                                      | Disabled                                                                 |
| Download Mode                                                                | Enabled: None or LAN or Group or Disabled                                |
| EMET 5.5 or higher is installed                                              | Enabled                                                                  |
| Default Action and Mitigation Settings                                       | Enabled                                                                  |
| Default Protections for Internet Explorer                                   | Enabled                                                                  |
| Default Protections for Popular Software                                    | Enabled                                                                  |
| Default Protections for Recommended Software                                | Enabled                                                                  |
| System ASLR                                                                  | Enabled: Application Opt-In                                              |
| System DEP                                                                   | Enabled: Application Opt-Out                                             |
| System SEHOP                                                                 | Enabled: Application Opt-Out                                             |
| Application: Control Event Log behavior when the log file reaches its maximum size | Disabled                                                             |
| Application: Specify the maximum log file size (KB)                         | Enabled: 32,768 or greater                                               |
| Security: Control Event Log behavior when the log file reaches its maximum size | Disabled                                                             |
| Security: Specify the maximum log file size (KB)                            | Enabled: 196,608 or greater                                              |
| Setup: Control Event Log behavior when the log file reaches its maximum size | Disabled                                                             |
| Setup: Specify the maximum log file size (KB)                               | Enabled: 32,768 or greater                                               |
| System: Control Event Log behavior when the log file reaches its maximum size | Disabled                                                             |
| System: Specify the maximum log file size (KB)                              | Enabled: 32,768 or greater                                               |
| Configure Windows SmartScreen                                                | Enabled: Require approval from an administrator before running downloaded unknown software |
| Turn off Data Execution Prevention for Explorer                             | Disabled                                                                 |
| Turn off heap termination on corruption                                      | Disabled                                                                 |
| Turn off shell protocol protected mode                                      | Disabled                                                                 |

# Windows 11 CIS Benchmark Compliance

This document outlines the necessary compliance rules that need to be implemented to achieve a higher compliance score with Wazuh on a Windows 11 machine.

## Compliance Table

| Section        | Benchmark Item                                   | Compliance Level | Configuration Requirement |
|---------------|------------------------------------------------|------------------|---------------------------|
| Desktop App Installer | Ensure 'Enable App Installer' is set to 'Disabled' | L1 | Automated |
| Desktop App Installer | Ensure 'Enable App Installer Experimental Features' is set to 'Disabled' | L1 | Automated |
| Desktop App Installer | Ensure 'Enable App Installer Hash Override' is set to 'Disabled' | L1 | Automated |
| Desktop App Installer | Ensure 'Enable App Installer ms-appinstaller protocol' is set to 'Disabled' | L1 | Automated |
| Event Log Service | Ensure 'Application: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled' | L1 | Automated |
| Event Log Service | Ensure 'Application: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater' | L1 | Automated |
| Event Log Service | Ensure 'Security: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled' | L1 | Automated |
| Event Log Service | Ensure 'Security: Specify the maximum log file size (KB)' is set to 'Enabled: 196,608 or greater' | L1 | Automated |
| Event Log Service | Ensure 'Setup: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled' | L1 | Automated |
| Event Log Service | Ensure 'Setup: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater' | L1 | Automated |
| Microsoft Defender Antivirus | Ensure 'Configure Attack Surface Reduction rules' is set to 'Enabled' | L1 | Automated |
| Microsoft Defender Antivirus | Ensure 'Prevent users and apps from accessing dangerous websites' is set to 'Enabled: Block' | L1 | Automated |
| Microsoft Defender Antivirus | Ensure 'Scan all downloaded files and attachments' is set to 'Enabled' | L1 | Automated |
| Microsoft Defender Antivirus | Ensure 'Turn on script scanning' is set to 'Enabled' | L1 | Automated |
| Microsoft Defender Antivirus | Ensure 'Turn off Microsoft Defender AntiVirus' is set to 'Disabled' | L1 | Automated |
| Microsoft Defender Application Guard | Ensure 'Allow auditing events in Microsoft Defender Application Guard' is set to 'Enabled' | L1 | Automated |
| Remote Desktop Services | Ensure 'Do not allow passwords to be saved' is set to 'Enabled' | L1 | Automated |
| Remote Desktop Services | Ensure 'Always prompt for password upon connection' is set to 'Enabled' | L1 | Automated |
| Remote Desktop Services | Ensure 'Require secure RPC communication' is set to 'Enabled' | L1 | Automated |
| Windows Update | Ensure 'Configure Automatic Updates' is set to 'Enabled' | L1 | Automated |
| Windows Update | Ensure 'Remove access to "Pause updates" feature' is set to 'Enabled' | L1 | Automated |
| Windows Security | Ensure 'Prevent users from modifying settings' is set to 'Enabled' | L1 | Automated |
| Windows Search | Ensure 'Allow Cortana' is set to 'Disabled' | L1 | Automated |
| Windows Search | Ensure 'Allow search and Cortana to use location' is set to 'Disabled' | L1 | Automated |
| Windows Store | Ensure 'Turn off the Store application' is set to 'Enabled' | L2 | Automated |

---

# Microsoft Edge CIS Benchmark Compliance

This document outlines the necessary compliance rules that need to be implemented to achieve a higher compliance score for Microsoft Edge.

## Compliance Table

| Section        | Benchmark Item                                   | Compliance Level | Configuration Requirement |
|---------------|------------------------------------------------|------------------|---------------------------|
| Application Guard | Ensure 'Enable Google Cast' is set to 'Disabled' | L1 | Automated |
| Content Settings | Ensure 'Allow read access via the File System API on these sites' is set to 'Disabled' | L2 | Automated |
| Content Settings | Ensure 'Control use of insecure content exceptions' is set to 'Enabled: Do not allow any site to load mixed content' | L1 | Automated |
| Content Settings | Ensure 'Control use of JavaScript JIT' is set to 'Enabled: Do not allow any site to run JavaScript JIT' | L2 | Automated |
| Content Settings | Ensure 'Control use of the File System API for reading' is set to 'Enabled: Don’t allow any site to request read access' | L2 | Automated |
| Content Settings | Ensure 'Control use of the File System API for writing' is set to 'Enabled: Don’t allow any site to request write access' | L1 | Automated |
| Content Settings | Ensure 'Control use of the Web Bluetooth API' is set to 'Enabled: Do not allow any site to request access' | L2 | Automated |
| Content Settings | Ensure 'Control use of the WebHID API' is set to 'Enabled: Do not allow any site to request access' | L2 | Automated |
| Content Settings | Ensure 'Default automatic downloads setting' is set to 'Enabled: Don’t allow any website to perform automatic downloads' | L1 | Automated |
| Content Settings | Ensure 'Default geolocation setting' is set to 'Enabled: Don’t allow any site to track users' physical location' | L1 | Automated |
| Content Settings | Ensure 'Default setting for third-party storage partitioning' is set to 'Enabled: Block third-party storage' | L2 | Automated |
| Default Search Provider | Ensure 'Configure Edge Website Typo Protection' is set to 'Enabled' | L1 | Automated |
| Experimentation | Ensure 'Configure users ability to override feature flags' is set to 'Enabled: Prevent users from overriding feature flags' | L1 | Automated |
| Extensions | Ensure 'Blocks external extensions from being installed' is set to 'Enabled' | L1 | Automated |
| HTTP Authentication | Ensure 'Allow Basic authentication for HTTP' is set to 'Disabled' | L1 | Automated |
| HTTP Authentication | Ensure 'Allow cross-origin HTTP Authentication prompts' is set to 'Disabled' | L1 | Automated |
| Identity and Sign-in | Ensure 'Enable the linked account feature' is set to 'Disabled' | L1 | Automated |
| Network Settings | Ensure 'Enable saving passwords to the password manager' is set to 'Disabled' | L1 | Automated |
| Performance | Ensure 'Enable startup boost' is set to 'Disabled' | L1 | Automated |
| Private Network Requests | Ensure 'Specifies whether to allow websites to make requests to more-private network endpoints' is set to 'Disabled' | L1 | Automated |
| SmartScreen | Ensure 'Configure Microsoft Defender SmartScreen' is set to 'Enabled' | L1 | Automated |
| SmartScreen | Ensure 'Prevent bypassing Microsoft Defender SmartScreen prompts for sites' is set to 'Enabled' | L1 | Automated |
| Startup and New Tab | Ensure 'Disable Bing chat entry-points on Microsoft Edge Enterprise new tab page' is set to 'Disabled' | L1 | Automated |
| Startup and New Tab | Ensure 'Allow import of data from other browsers on each Microsoft Edge launch' is set to 'Disabled' | L1 | Automated |
| Proxy Server | Ensure 'Allow download restrictions' is set to 'Enabled: Block malicious downloads' | L1 | Automated |
| Printing | Ensure 'Enable Microsoft Defender SmartScreen to block potentially unwanted apps' is set to 'Enabled' | L1 | Automated |
| Microsoft Edge Update | Ensure 'Update policy override default' is set to 'Enabled: Always allow updates (recommended)' | L1 | Automated |

---
# Google Chrome CIS Benchmark Compliance

This document outlines the necessary compliance rules that need to be implemented to achieve a higher compliance score for Google Chrome.

## Compliance Table

| Section        | Benchmark Item                                   | Compliance Level | Configuration Requirement |
|---------------|------------------------------------------------|------------------|---------------------------|
| HTTP Authentication | Ensure 'Cross-origin HTTP Authentication prompts' is set to 'Disabled' | L1 | Automated |
| Safe Browsing | Ensure 'Configure the list of domains on which Safe Browsing will not trigger warnings' is set to 'Disabled' | L1 | Automated |
| Safe Browsing | Ensure 'Safe Browsing Protection Level' is set to 'Enabled: Safe Browsing is active in the standard mode.' or higher | L1 | Manual |
| Security Settings | Ensure 'Allow Google Cast to connect to Cast devices on all IP addresses' is set to 'Disabled' | L1 | Automated |
| Security Settings | Ensure 'Allow queries to a Google time service' is set to 'Enabled' | L1 | Automated |
| Security Settings | Ensure 'Allow the audio sandbox to run' is set to 'Enabled' | L1 | Automated |
| Security Settings | Ensure 'Ask where to save each file before downloading' is set to 'Enabled' | L1 | Automated |
| Privacy Settings | Ensure 'Continue running background apps when Google Chrome is closed' is set to 'Disabled' | L1 | Automated |
| Privacy Settings | Ensure 'Control SafeSites adult content filtering' is set to 'Enabled: Filter top level sites for adult content' | L2 | Automated |
| Certificate Settings | Ensure 'Disable Certificate Transparency enforcement for a list of Legacy Certificate Authorities' is set to 'Disabled' | L1 | Automated |
| Certificate Settings | Ensure 'Disable Certificate Transparency enforcement for a list of URLs' is set to 'Disabled' | L1 | Automated |
| DNS Settings | Ensure 'DNS interception checks enabled' is set to 'Enabled' | L1 | Automated |
| Security Warnings | Ensure 'Enable security warnings for command-line flags' is set to 'Enabled' | L1 | Automated |
| Extensions | Ensure 'Blocks external extensions from being installed' is set to 'Enabled' | L1 | Automated |
| Extensions | Ensure 'Configure allowed app/extension types' is set to 'Enabled: extension, hosted_app, platform_app, theme' | L1 | Automated |
| Extensions | Ensure 'Configure extension installation blocklist' is set to 'Enabled: *' | L1 | Automated |
| Privacy | Ensure 'Enable deleting browser and download history' is set to 'Disabled' | L1 | Automated |
| Updates | Ensure 'Update policy override' is set to 'Enabled: Always allow updates (recommended)' or 'Automatic silent updates' specified | L1 | Automated |
| Content Settings | Ensure 'Control use of insecure content exceptions' is set to 'Enabled: Do not allow any site to load mixed content' | L1 | Automated |
| Content Settings | Ensure 'Control use of the Web Bluetooth API' is set to 'Enabled: Do not allow any site to request access to Bluetooth devices' | L2 | Automated |
| Printing | Ensure 'Enable Google Cloud Print Proxy' is set to 'Disabled' | L1 | Automated |
| Remote Access | Ensure 'Allow remote access connections to this machine' is set to 'Disabled' | L1 | Manual |
| Remote Access | Ensure 'Enable firewall traversal from remote access host' is set to 'Disabled' | L1 | Automated |
| Security | Ensure 'Enable Renderer App Container' is set to 'Enabled' | L1 | Automated |
| Security | Ensure 'Enable strict MIME type checking for worker scripts' is set to 'Enabled' | L1 | Automated |
| Security | Ensure 'Allow Web Authentication requests on sites with broken TLS certificates' is set to 'Disabled' | L1 | Automated |
| Privacy | Ensure 'Enable alternate error pages' is set to 'Disabled' | L1 | Automated |
| Privacy | Ensure 'Enable URL-keyed anonymized data collection' is set to 'Disabled' | L1 | Automated |

---

# Microsoft Office CIS Benchmark Compliance

This document outlines the necessary compliance rules that need to be implemented to achieve a higher compliance score for Microsoft Office.

## Compliance Table

| Section                | Benchmark Item                                                                                     | Compliance Level | Configuration Requirement |
|-----------------------|--------------------------------------------------------------------------------------------------|------------------|---------------------------|
| Security Settings     | Ensure 'Allow mix of policy and user locations' is set to 'Disabled'                              | L1               | Automated                 |
| Security Settings     | Ensure 'ActiveX Control Initialization' is set to 'Enabled: 6'                                    | L1               | Automated                 |
| Security Settings     | Ensure 'Allow Basic Authentication prompts from network proxies' is set to 'Disabled'             | L1               | Automated                 |
| Security Settings     | Ensure 'Allow VBA to load typelib references by path from untrusted intranet locations' is set to 'Disabled' | L1 | Automated |
| Security Settings     | Ensure 'Automation Security' is set to 'Enabled: Disable Macros by default'                      | L1               | Automated                 |
| Security Settings     | Ensure 'Control how Office handles form-based sign-in prompts' is set to 'Enabled: Block all prompts' | L1 | Automated |
| Security Settings     | Ensure 'Disable additional security checks on VBA library references' is set to 'Disabled'        | L1               | Automated                 |
| Security Settings     | Ensure 'Disable all Trust Bar notifications for security issues' is set to 'Disabled'             | L1               | Automated                 |
| Security Settings     | Ensure 'Disable password to open UI' is set to 'Disabled'                                         | L1               | Automated                 |
| Security Settings     | Ensure 'Encryption mode for Information Rights Management (IRM)' is set to 'Enabled: CBC'         | L1               | Automated                 |
| Security Settings     | Ensure 'Encryption type for password protected Office 97-2003 files' is set to 'Enabled'          | L1               | Automated                 |
| Security Settings     | Ensure 'Encryption type for password protected Office Open XML files' is set to 'Enabled'         | L1               | Automated                 |
| Security Settings     | Ensure 'Macro Runtime Scan Scope' is set to 'Enabled: Enable for all documents'                   | L1               | Automated                 |
| Security Settings     | Ensure 'Protect document metadata for password protected files' is set to 'Enabled'               | L1               | Automated                 |
| Server Settings       | Ensure 'Disable the Office client from polling the SharePoint Server for published links'         | L1               | Automated                 |
| Services              | Ensure 'Disable Internet Fax feature' is set to 'Enabled'                                         | L1               | Automated                 |
| Signing               | Ensure 'Legacy format signatures' is set to 'Disabled'                                            | L1               | Automated                 |
| Signing               | Ensure 'Suppress external signature services menu item' is set to 'Enabled'                       | L1               | Automated                 |
| Smart Documents       | Ensure 'Disable Smart Document's use of manifests' is set to 'Enabled'                            | L1               | Automated                 |
| Outlook Settings      | Ensure 'Authentication with Exchange server' is set to 'Enabled: Kerberos Password Authentication' | L1 | Automated |
| Outlook Settings      | Ensure 'Do not allow users to change permissions on folders' is set to 'Enabled'                   | L1 | Automated |
| Outlook Settings      | Ensure 'Enable RPC encryption' is set to 'Enabled'                                                 | L1 | Automated |
| Outlook Settings      | Ensure 'Automatically download attachments' is set to 'Disabled'                                  | L1 | Automated |
| Outlook Settings      | Ensure 'Do not include Internet Calendar integration in Outlook' is set to 'Enabled'               | L1 | Automated |
| Outlook Settings      | Ensure 'Download full text of articles as HTML attachments' is set to 'Disabled'                   | L1 | Automated |
| Outlook Settings      | Ensure 'Turn off RSS feature' is set to 'Enabled'                                                  | L1 | Automated |

---
# Microsoft Office Word 2016 CIS Benchmark Compliance

This document outlines the necessary compliance rules that need to be implemented to achieve compliance with the CIS Benchmark for Microsoft Office Word 2016.

## Compliance Table

| Section        | Benchmark Item                                   | Compliance Level | Configuration Requirement |
|---------------|------------------------------------------------|------------------|---------------------------|
| Collaboration Settings | Ensure 'Use Online Translation Dictionaries' is set to 'Disabled' | L1 | Scored |
| Word Options | Ensure 'Custom Markup Warning' is set to 'Enabled' | L1 | Scored |
| Word Options | Ensure 'Update Automatic Links at Open' is set to 'Disabled' | L1 | Scored |
| Word Options | Ensure 'Hidden Text' is set to 'Enabled' | L1 | Scored |
| Word Options | Ensure 'Default File Format' is set to 'Enabled (Word Document .docx)' | L1 | Scored |
| Word Options | Ensure 'Default File Block Behavior' is set to 'Enabled (Blocked files are not opened)' | L1 | Scored |
| Word Options | Ensure 'Word 2 and Earlier Binary Documents and Templates' is set to 'Enabled (Open/Save blocked, use open policy)' | L1 | Scored |
| Word Options | Ensure 'Word 6.0 Binary Documents and Templates' is set to 'Enabled (Open/Save blocked, use open policy)' | L1 | Scored |
| Word Options | Ensure 'Word 95 Binary Documents and Templates' is set to 'Enabled (Open/Save Blocked, Use Open Policy)' | L1 | Scored |
| Word Options | Ensure 'Word 97 Binary Documents and Templates' is set to 'Enabled (Open/Save Blocked, Use Open Policy)' | L1 | Scored |
| Word Options | Ensure 'Do Not Open Files from The Internet Zone in Protected View' is set to 'Disabled' | L1 | Scored |
| Word Options | Ensure 'Do Not Open Files in Unsafe Locations in Protected View' is set to 'Disabled' | L1 | Scored |
| Word Options | Ensure 'Turn Off Protected View for Attachments Opened from Outlook' is set to 'Disabled' | L1 | Scored |
| Word Options | Ensure 'Document Behavior if File Validation Fails' is set to 'Enabled (Open in Protected View)' | L1 | Scored |
| Word Options | Ensure 'Allow Trusted Locations on the Network' is set to 'Disabled' | L1 | Scored |
| Word Options | Ensure 'Disable All Trusted Locations' is set to 'Enabled' | L1 | Scored |
| Word Options | Ensure 'Scan Encrypted Macros in Word Open XML Documents' is set to 'Enabled' | L1 | Scored |
| Word Options | Ensure 'Disable Trust Bar Notification for Unsigned Application Add-ins and Block Them' is set to 'Enabled' | L1 | Scored |
| Word Options | Ensure 'Require That Application Add-ins Are Signed By Trusted Publisher' is set to 'Enabled' | L1 | Scored |
| Word Options | Ensure 'Trust Access to Visual Basic Project' is set to 'Disabled' | L1 | Scored |
| Word Options | Ensure 'VBA Macro Notification Settings' is set to 'Enabled (Disable all Except Digitally Signed)' | L1 | Scored |
| Word Options | Ensure 'Make Hidden Markup Visible' is set to 'Enabled' | L1 | Scored |
| Word Options | Ensure 'Turn Off File Validation' is set to 'Disabled' | L1 | Scored |
| Word Options | Ensure 'Warn Before Printing, Saving or Sending a File That Contains Tracked Changes or Comments' is set to 'Enabled' | L1 | Scored |
| Word Options | Ensure 'Turn Off Protected View for Attachments Opened from Outlook' is set to 'Disabled' | L1 | Scored |
| Word Options | Ensure 'Allow Trusted Locations on the Network' is set to 'Disabled' | L1 | Scored |

---

# Enable Ctrl+Alt+Del Login in Windows 11  

Enhance your system security by enabling the **Ctrl+Alt+Del** login prompt on Windows 11. Follow the steps below to configure this setting.  

## Steps to Enable  

1. **Open the Run Command**  
   Press `Win + R` to open the **Run** dialog box.
   
   <div align="center">
     <img src="https://github.com/user-attachments/assets/bce5ea82-9060-46db-822e-a869ed388d8a" height="200"></img>
   </div>
   
3. **Access User Account Settings**  
   Type the following command and press **Enter**:  
   ```  
   control userpasswords2  
   ```

   <div align="center">
     <img src="https://github.com/user-attachments/assets/6cc96e44-6bdc-4069-a0ee-589bee07a2af" height="400"></img>
   </div>
     
5. **Modify Advanced Settings**  
   - Navigate to the **Advanced** tab.  
   - Under **Secure sign-in**, check the option **"Require users to press Ctrl+Alt+Delete"**.  
   
   <div align="center">
     <img src="https://github.com/user-attachments/assets/f22f1b1c-e098-4641-a9f5-846ce30f9d37" height="400"></img>
   </div>
     

6. **Apply Changes & Restart**  
   Click **OK** to save the changes, then **restart your system** for the modifications to take effect.



# Powershell Script to maintain Password Policy

#### Policy’s
* Minimum password age (days) : `45`
* Maximum password age (days)" `60`
* Minimum password length: `8`
* Length of password history maintained: `5`
* Lockout threshold: `5`
* Lockout duration (minutes): `10`
* Lockout observation window (minutes): `10`
* Turns ON the screen saver: `yes`
* Require Password on Resume: `yes`
* Set Idle Timeout (10 mins): `yes`

```
net accounts /maxpwage:60
net accounts /minpwage:45
net accounts /minpwlen:8
net accounts /uniquepw:5
# ACCOUNT LOCKOUT POLICY
net accounts /lockoutthreshold:5
net accounts /lockoutduration:30
net accounts /lockoutwindow:30
# USER-LEVEL ENFORCEMENT (IMPORTANT)
net user $USER /passwordreq:yes
# SCREEN LOCK POLICY (10 mins)
reg add "HKCU\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 1 /f
reg add "HKCU\Control Panel\Desktop" /v ScreenSaverIsSecure /t REG_SZ /d 1 /f
reg add "HKCU\Control Panel\Desktop" /v ScreenSaveTimeOut /t REG_SZ /d 600 /f

# POWER / DISPLAY TIMEOUT
powercfg /change monitor-timeout-ac 10
# To Recheck 
net Accounts
```
