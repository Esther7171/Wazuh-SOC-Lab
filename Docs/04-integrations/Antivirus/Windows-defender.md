# Integrating Wazuh with Microsoft Defender Logs on Windows

You just finished setting up Wazuh and the first thing you want is visibility. Makes sense. Before installing agents everywhere, it’s smart to wire up Microsoft Defender logs so every Windows machine reports what Defender is actually seeing.

So how do we do this cleanly and in a way that scales for future agents?

This guide walks through all working paths. Default agent config, group based config, and the manual fallback when nothing else pushes.

---

## Default Agent Configuration (Best Practice Before Installing Agents)

If you haven’t deployed any agents yet, this is the cleanest move. Anything you define here will automatically apply to all future agents.

Log in to your Wazuh server and open the default agent configuration file.

```
nano /var/ossec/etc/shared/default/agent.conf
```

Add the Defender event channel configuration below.

```xml
<localfile>
  <location>Microsoft-Windows-Windows Defender/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
```

<div align="center">
  <img width="840" height="179" alt="image" src="https://github.com/user-attachments/assets/a9588d58-4d77-484a-b8fb-6f9f73cb2fbb" />
</div>


Save the file. That’s it.

Every new Windows agent you install from now on will start shipping Defender logs without touching the endpoint again. This is how it should be done when building fresh.

---

## Applying Defender Logs Using Agent Groups (Already Installed Agents)

Already deployed agents and using groups? No problem. You can push the same configuration from the Wazuh Dashboard.

### Step 1: Open the Wazuh Dashboard

Open the dashboard and click the menu icon in the top left corner.

<div align="center">
<img src="https://github.com/user-attachments/assets/b321077b-bc37-4c2a-9008-42203f2a5809" height="400"></img>
</div>

---

### Step 2: Go to Agent Groups

Search for Group in the menu and open it.
Choose the group you want and click the edit icon.

<div align="center">
<img src="https://github.com/user-attachments/assets/eb1c4361-ad03-400a-b899-a782d7a2c3de"></img>
</div>

---

### Step 3: Edit agent.conf for the Group

Open the agent.conf editor for the group.

<div align="center">
<img src="https://github.com/user-attachments/assets/cbb310fd-445a-4970-b385-45d1b3408a32"></img>
</div>

Paste the Defender configuration.

```xml
<localfile>
  <location>Microsoft-Windows-Windows Defender/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
```

Save the changes.

---

### Step 4: Apply and Sync

Once saved, the configuration will sync automatically. In most cases, agents pick this up without restart. If logs do not appear immediately, restarting the agent helps.

<div align="center">
<img src="https://github.com/user-attachments/assets/d48aba16-881e-4687-a6c5-cf9805c98b59"></img>
</div>

---

## Manual Setup (Old Agents Not Receiving Group Updates)

Sometimes agents are old. Sometimes they drift. Sometimes group sync just refuses to cooperate.

If the Defender logs are still missing, this manual method always works.

---

## Step 1: Open the Wazuh Agent Config on Windows

Open an elevated terminal or Run dialog and launch Notepad as administrator.

```
notepad.exe "C:\Program Files (x86)\ossec-agent\ossec.conf"
```

If Windows asks for permission, allow it.

---

## Step 2: Add Defender Event Channel

Scroll near the bottom of the file.
Paste this block **before** the closing `</ossec_config>` tag.

```xml
<localfile>
  <location>Microsoft-Windows-Windows Defender/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
```

### What are we actually telling Wazuh here?

The localfile tag tells the agent to watch a log source.
The location points to Defender’s Event Viewer channel.
The eventchannel format tells Wazuh this is a Windows event log, not a flat file.

Simple, but powerful.

---

## Step 3: Restart the Wazuh Agent

Configuration changes do nothing until the agent reloads.

Restart it using PowerShell.

```ps1
Restart-Service -Name wazuh
```

Within seconds, Defender events should start flowing to the manager.

---

## Verifying Defender Logs

If you want to double check the log source manually, open Event Viewer and navigate to:

```
Applications and Services Logs
Microsoft
Windows
Windows Defender
Operational
```

If events exist there and the agent is running, Wazuh will ingest them.

---

## Additional References

Official Wazuh blog on Windows detection
[https://wazuh.com/blog/detecting-powershell-exploitation-techniques-in-windows-using-wazuh/](https://wazuh.com/blog/detecting-powershell-exploitation-techniques-in-windows-using-wazuh/)