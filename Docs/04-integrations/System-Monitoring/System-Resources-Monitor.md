Add the following configuration to the `<ossec_config>` block of the `ossec.conf` file located at `C:\Program Files (x86)\ossec-agent`:

```ps
notepad.exe 'C:\Program Files (x86)\ossec-agent\ossec.conf'
```
Past This:
```xml
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


# 📊 Monitoring Windows resources with Performance Counters

This guide shows you how to monitor **CPU**, **memory**, **network traffic**, and **disk space** using **PowerShell commands** in the Wazuh agent.

Wazuh will collect these metrics every minute and send them to your Wazuh manager for visibility and alerting.

---

## ⚙️ Step 1: Open the Wazuh Agent Configuration File

We need to tell Wazuh what system metrics to collect. This is done by editing its config file.

### ✅ Do this:

1. Open **Command Prompt as Administrator**.
2. Paste and run the following command to open the config file in Notepad:

```ps
notepad.exe "C:\Program Files (x86)\ossec-agent\ossec.conf"
```

> This file controls what the Wazuh agent monitors. We’ll add our performance monitoring commands here.

---

## 🧩 Step 2: Add the Performance Monitoring Configuration

Scroll to the section with `<ossec_config>` and paste the following block **before the closing `</ossec_config>` tag**:

```xml
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

### 🧠 What’s happening here?

* Each `<wodle name="command">` block runs a **PowerShell performance counter**.
* Wazuh runs it **every 1 minute** (`<interval>1m</interval>`) and collects the output.
* The result is converted to **JSON**, making it easy for Wazuh to parse and analyze.
* The `<tag>` helps label the data, so you can search for it easily in Wazuh dashboards.

---

## 🔄 Step 3: Restart the Wazuh Agent

To apply the changes, restart the Wazuh agent.

### ✅ Do this:

Open Command Prompt as Administrator and run:

```cmd
net stop wazuh
net start wazuh
```

Or use the Wazuh Agent GUI:

* Open the **Wazuh Agent Manager**
* Click **Stop**, then **Start**

---

## 📈 You’re Done!

Your Wazuh agent is now tracking:

* 🧠 **CPU usage**
* 💾 **Available memory**
* 🌐 **Network traffic (in/out)**
* 📀 **Free disk space**

You can view these logs in your **Wazuh dashboard**, use them to create **alerts**, or just monitor system health over time.

---

## 🛠 Troubleshooting

* Make sure PowerShell is installed and accessible (Windows has it by default).
* If something doesn’t appear in Wazuh, check the agent logs in:

  ```
  C:\Program Files (x86)\ossec-agent\logs\ossec.log
  ```
* If you use a restrictive environment (e.g., hardened servers), PowerShell execution policies may block scripts. You may need to allow them with:

```ps
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
```

