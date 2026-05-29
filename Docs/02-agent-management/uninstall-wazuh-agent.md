# Uninstalling the Wazuh Agent from the Endpoint

When I need to remove a Wazuh agent from any system, I follow a structured approach so nothing gets left behind. Below is how I handle the uninstallation process across Linux, Windows, macOS, Solaris, AIX, and HP-UX. This guide also works great for SEO if you're publishing documentation or a blog.

## Uninstalling a Linux Wazuh Agent

When I’m uninstalling a Linux agent, I start by removing the package and then check if any configuration files are still hanging around.

### Removing the Wazuh Package

**apt**

```
apt-get remove wazuh-agent
```

If I want every trace gone, including config files:

```
apt-get remove --purge wazuh-agent
```

**yum**

```
yum remove wazuh-agent
```

**dnf**

```
dnf remove wazuh-agent
```

**zypper**

```
zypper remove wazuh-agent
```

Some package managers leave behind configuration files. If I want a completely clean system, I manually delete:

```
/var/ossec/
```

### Disabling the Service

After removing the package, I make sure the service is disabled:

```
systemctl disable wazuh-agent
systemctl daemon-reload
```

At this point, the Linux endpoint is free of the Wazuh agent.

---

## Uninstalling a Windows Wazuh Agent

To remove the Windows agent, I use the original MSI installer. I keep the file in my working directory and run:

```
msiexec.exe /x wazuh-agent-4.14.1-1.msi /qn
```

Once the installer completes, the agent is fully removed from the Windows machine.

---

## Uninstalling a macOS Wazuh Agent

On macOS, I prefer walking through the cleanup step by step so everything is wiped properly.

### Stop the Agent Service

```
launchctl bootout system /Library/LaunchDaemons/com.wazuh.agent.plist
```

### Remove Wazuh Files

```
/bin/rm -r /Library/Ossec
```

### Remove LaunchDaemons and StartupItems

```
/bin/rm -f /Library/LaunchDaemons/com.wazuh.agent.plist
/bin/rm -rf /Library/StartupItems/WAZUH
```

### Remove the Wazuh User and Group

```
/usr/bin/dscl . -delete "/Users/wazuh"
/usr/bin/dscl . -delete "/Groups/wazuh"
```

### Clean pkgutil Records

```
/usr/sbin/pkgutil --forget com.wazuh.pkg.wazuh-agent
```

After this, the macOS system is completely clean.

---

## Uninstalling a Solaris Wazuh Agent

### Solaris 10

I uninstall the agent with:

```
pkgrm wazuh-agent
```

That clears the endpoint.

---

## Uninstalling an AIX Wazuh Agent

On AIX, I run:

```
rpm -e wazuh-agent
```

If configuration files remain behind, I clean them manually:

```
/var/ossec/
```

Once removed, the AIX machine is clean.

---

## Uninstalling an HP-UX Wazuh Agent

To finish the cleanup on HP-UX, I follow these steps:

### Stop the Agent

```
/var/ossec/bin/wazuh-control stop
```

### Remove the Wazuh User and Group

```
groupdel wazuh
userdel wazuh
```

### Remove Remaining Files

```
rm -rf /var/ossec
```

Now the HP-UX endpoint is fully cleared.

---

# Uninstalling Wazuh Agents from the Server Side

If I want to remove agent entries directly from the Wazuh server, I open the agent manager:

```
/var/ossec/bin/manage_agents
```

I select the **R** option to remove an agent and I enter the ID of the one I want gone:

```
Provide the ID of the agent to be removed:
```

After confirming the deletion, the server removes the agent entry completely.

---

If you’d like, I can also format this into a downloadable PDF, DOCX, or a blog-ready HTML page.
