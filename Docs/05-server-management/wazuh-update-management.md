# Wazuh Update Management

This guide explains how to update the Wazuh server and disable automatic Wazuh repository updates to avoid unexpected version upgrades.

---

## Update the System

Run the following command to update system packages:

```bash
sudo apt update -y && sudo apt upgrade -y
```

---

## Disable Wazuh Repository Updates

> **Recommended**
> Disable automatic Wazuh repository updates after installation to prevent accidental upgrades that could break the environment or create version compatibility issues.

Disable the Wazuh repository using:

```bash
sudo sed -i "s/^deb /#deb /" /etc/apt/sources.list.d/wazuh.list
sudo apt update
```

---

## Verify Repository Status

Check whether the repository has been disabled successfully:

```bash
cat /etc/apt/sources.list.d/wazuh.list
```

You should see the repository line commented with `#`.

---

## Conclusion

You have successfully updated the system and disabled automatic Wazuh repository updates.