
# <div align="center">Wazuh Complete Documentation Hub</div>
<div align="center">
<img src="https://github.com/user-attachments/assets/818c4229-e59a-41b6-a10a-ef8d4775c076" height="200"></img>
</div>
<div align="center">

*A structured, search-optimized guide for deploying, managing, and hardening Wazuh.*

If this repository helps you, please ⭐ **star the repo**.

</div>


---

> # Table of Contents

---

# 1. Agent

### ▸ [How to enroll/register a Wazuh agent (Windows/Linux/macOS)](Docs/Agent/Enroll.md)  
### ▸ [How to uninstall the Wazuh agent](Docs/Agent/Uninstall.md)  
### ▸ [How to upgrade Wazuh agents remotely](Docs/Agent/Upgrade-remote.md)  

### Additional Configurations  
### ▸ [Master Agent Config Guide](Docs/Master-Agent-config.md)

---

# 2. Dashboard

### ▸ [How to change the default Wazuh Dashboard admin password](Docs/Dashboard/Change-default-password.md)  
### ▸ [How to set up a custom domain + SSL for Wazuh Dashboard](Docs/Dashboard/Custom-domain-ssl-setup.md)  
### ▸ [How to rebrand/customize the Wazuh Dashboard UI](Docs/Dashboard/Rebranding.md)

---

# 3. Installation

### ▸ [All-In-One Wazuh Installation](Docs/Installation/All-In-One.md)  
### ▸ [Change Wazuh Dashboard default password (Installer-specific)](Docs/Installation/Change-wazuh-Default-dashboard-Passord.md)  
### ▸ [Wazuh Installation using Docker](Docs/Installation/docker-installation.md)  
### ▸ [Manual Step-by-Step Wazuh Setup](Docs/Installation/manuall-setup.md)

---

# 4. Integrations

## Alerts  
### ▸ [Mail Alerts Integration](Docs/Integrations/Alerts/Mail-Integration.md)  
### ▸ [Microsoft Teams Alerts Integration](Docs/Integrations/Alerts/Microsoft-Teams.md)  
### ▸ [Slack Alerts Integration](Docs/Integrations/Alerts/Slack.md)  
### ▸ [Telegram Bot Alerts Integration](Docs/Integrations/Alerts/Telegram-bot.md)

---

## Antivirus  
### ▸ [Windows Defender Integration](Docs/Integrations/Antivirus/Windows-defender.md)

---

## System Monitoring  
### ▸ [Sysmon for Windows Log Collection](Docs/Integrations/System-Monitoring/Sysmon-for-Logs.md)  
### ▸ [System Resource Monitoring (CPU / RAM / Disk)](Docs/Integrations/System-Monitoring/System-Resources-Monitor.md)

---

##  Threat Hunting  
### ▸ [Criminal IP Threat Intelligence Integration](Docs/Integrations/Threat-Hunting/Criminal-IP.md)  
### ▸ [PowerShell Exploitation Detection](Docs/Integrations/Threat-Hunting/Powershell-detection.md)  
### ▸ [VirusTotal Hash Lookup Integration](Docs/Integrations/Threat-Hunting/Virus-total.md)  
### ▸ [YARA + FIM based Threat Detection](Docs/Integrations/Threat-Hunting/Yara+fim.md)

---

# 5. Compliance

### ▸ [Compliance & CIS Benchmark Overview](Docs/Compliance/Overview.md)

---

# 6. Master Server Configuration

### ▸ [Test Reference](Docs/Master-Server-config/test.readme.md)  
### ▸ [Wazuh Services Auto-Restarter Script](Docs/Master-Server-config/wazuh-services-restarter.md)

---

# 7. Server Hardening

### ▸ [Wazuh Server Hardening Guide](Docs/Server-hardening/Server-harding.md)  
### ▸ [SSH Banner Configuration](Docs/Server-hardening/SSH-banner.md)  
### ▸ [SSH Connect Helper Script](Docs/Server-hardening/connect-to-ssh.bat)

---

# ❓ FAQ

### **Q1: How do I install Wazuh on Linux/Ubuntu?**  
See: [All-In-One Installation](Docs/Installation/All-In-One.md)

### **Q2: How do I uninstall a Wazuh agent?**  
See: [Uninstallation Guide](Docs/Agent/Uninstall.md)

### **Q3: How do I integrate VirusTotal with Wazuh?**  
See: [VirusTotal Integration](Docs/Integrations/Threat-Hunting/Virus-total.md)

### **Q4: How do I detect PowerShell attacks?**  
See: [PowerShell Detection](Docs/Integrations/Threat-Hunting/Powershell-detection.md)

### **Q5: How do I monitor system resources?**  
See: [System Resource Monitor](Docs/Integrations/System-Monitoring/System-Resources-Monitor.md)

### **Q6: How to configure Windows Defender logs?**  
See: [Windows Defender Integration](Docs/Integrations/Antivirus/Windows-defender.md)

### **Q7: How do I send alerts to Slack/Teams/Mail/Telegram?**  
See: [Alerts Integrations](Docs/Integrations/Alerts)

> # Introduction to Wazuh
OSSEC is open source HIDS security platform and a Host Intrusion Detection System(HIDS) software. Created by Daniel CID in year 2004, In year 2015 it forked from OSSEC AND Wazuh platform was created  

> # What is HIDS ?
Host-Based Intrusion Detection System that install directly on endpoint or servers. Purpose is basically to identify any Malicious activities or policy violations on individual hosts or devices. Deployed on each device or host that needs to be monitord
For example: Realted to Memory,Suspicious Process, Installlation of  ROOT-KIT , KERNAL LV Activity.
> OSSEC Features
* Log Analysis
* File Integrity
* Rootkit Detection
* Real-Time Alerts
* Compliance

> # How Wazuh is different from OSSEC ?
* Vulnerability Detection
* Security Configuration Assessment (SCS) ---> (CISB)
* Cloud Security (AWS,AZURE,GOOGLE CLOUD...)
* Comprehensive Dashboard
* Integration
* Better Community Support


> # [Components of Wazuh](https://github.com/Esther7171/Wazuh/edit/main/README.md#components-of-wazuh)

<div align="center">
<img src="https://github.com/user-attachments/assets/f3d5b53d-73a6-4cfd-bbf4-195e2641192d" height=""></img>
</div>

| S.no | Components |
|------|------------|
|1.| Agent|
|2.|Server|
|3.|Indexer|
|4.|Dashboard|


# Wazuh Agent: It Installed on endpoints.

## Agent Modules:

| S.No | Agent Modules | Description|
|------|---------------|------------|
|1.|Active response| Incident Response,Kind of script which will be triggered once specific rules ment|
|2.|Command Execution| Monitor running commands on Terminal |
|3.|Configuration Assessment| used as security audit | 
|4.|Container Security| Docker,Kubernetes,Openshift|
|5.|Cloud Security| Aws,Azure,GCP |
|6.|File Integrity Monitoring | It is used to Monitor any file additon,Edit,deletion, ownership and permission|
|7.|Log Collector| Collect logs|
|8.|Malware Detection| Detect malicious files |
|9.|System Inventory| Monitor installed app,storage|

## Agent Daemon:

| S.No | Agent Modules |
|------|---------------|
|1.|Data Encryption |
|2.|Modules Management |
|3.|Remote Configuration |
|4.|Server Authentication |

## IF any of these Collect Logs It will immediately send it to Centeral Components -> Wazuh Server

## Wazuh Server

<div align="center">
<img width="5567" alt="wazuh-chart" src="https://github.com/user-attachments/assets/0e425c0b-6539-42ab-b06d-3644db5f459a">
</div>

## What is Difference between Component and Architecture
| Component |  Architecture |
|-----------|---------------|
| The component talks about smaller scope focuing majorly on functionality and on differenet services mor different modules | This is all baout high level structure of your software this is about preformace of your system, The preformance of the system improvced when you have better scalability and elasticity and databse and Securitiy Function and how do youi maintain the entire infrastructure |

# Architecture of Wazuh

<div align="center">
<img src="https://github.com/user-attachments/assets/2bc6cbbd-a09a-4911-8101-2a1bae2c83a7">
</div>

<div align="center">
<img width="2959" alt="wazuh arch" src="https://github.com/user-attachments/assets/93e45c66-f9f1-4032-8032-8a0f85322f3d">
</div>

## Wazuh Features and Capabilities

| S.no | Feature | Discription |
|------|---------|-------------|
| 1. | Intrusion Detection | Scan and Monitor Endpoints. Llook for rootkit, malware, detect hidden file and unregiter network listners.
| 2. | Log Data Analysis | Read os logs and app logs  then encript it and send it to manager or server on rule base analysis. We still get data form sys logs like ```Router or switches```
| 3. | File Integrity Monitoring | Wazuh Monitor the file system  Identify any changes in the content, permission, ownership and different attributes of file and generates an alert when there is any unauthorized changes. We can join pci  



# Wazuh Integrations
>  ## Antivirus
- [ ] CLamAV
- [ ] Kaspersky Antivirus
- [ ] McAfee
- [ ] Sophos
- [ ] Symantec Endpoint Protection

>  ## Endpoint Detection and Response (EDR)
- [ ] CrowdStrick Falcon
- [ ] Carbon Black
- [ ] Cylance PROTECT
- [ ] Sentinel One
- [ ] Microsoft Defender for Endpoint

>  ## SOAR (Security Orchestration Automation,and Response)
- [ ] Shuffle SOAR
- [ ] Cortex XSOAR
- [ ] Siemplify
- [ ] Swimlane

>  ## Incident Response
- [ ] TheHive
- [ ] MISP (Malware Information Sharing Platform)
- [ ] IR Flow
- [ ] IBM Resilient
- [ ] Splunk Phantom

> ## Threat Intelligence
- [ ] Virus Total
- [ ] AlienValut OTX
- [ ] IBM X-Force Exchange
- [ ] Recorded Future
- [ ] Threat Connect

> ## Intrusion Detection System (IDS) / Intrusion Prevention System (IPS)
- [ ] Suricata
- [ ] Snort
- [ ] Zeek (formerly bro)

> ## Log Management
- [ ] Graylog
- [ ] Grafana
- [ ] Elastic Stack

> ## Cloud Security
- [ ] AWS CloudTrail
- [ ] Azure Security Center
- [ ] Google Cloud Security Command Center
- [ ] Cloudflare

# Installation guide
Wazuh Have 3 central components
* Wazuh Indexer
* Wazuh Server
* Wazuh Dashboard

The Wazuh indexer and Wazuh server can be installed on a single host or be distributed in cluster configurations. You can choose between two installation methods for each Wazuh central component. Both options provide instructions to install the central components on a single host or on separate hosts.

## Single node Deployment (Reccmonded for New Users) 
1. All-in-One deploument

## Multi node deployment.
It  have 2 nodes
1. master
2. worker
3. it will be indexer
4. dashboard

### Deployment Methods

* Distributed Servers
* Virtual Machine
* Amazon Machine Image (AMI)
* Docker
* Kubernetes

Check This Page For [Installation Guide](./Files/Installation)

## Requirements For Installation

The Wazuh indexer requires a 64-bit Intel or AMD Linux processor (x86_64/AMD64 architecture) to run. Wazuh supports the following operating system versions:

| S.No | Os | Component | RAM (GB) | CPU (cores) | RAM (GB) | CPU (cores)
|--|--|--|--|--|--|--|
| 1. | Ubuntu 16.04, 18.04, 20.04, 22.04, 24.04 | Wazuh indexer | 4 | 2 | 16 | 8 |
| 2. | Red Hat Enterprise Linux 7, 8, 9 | Wazuh server | 2 | 2 | 4 | 8 |
| 3. | CentOS 7, 8 | Wazuh dashboard | 4 | 2 | 8 | 4 |
| 4. | Amazon Linux 2, Amazon Linux 2023 |



<div align="center">

### 🤝 Contributions Welcome  
Feel free to open issues or submit PRs to enhance these docs.

### ⭐ Support  
If this documentation helped you, please **give the repo a star**.

</div>
