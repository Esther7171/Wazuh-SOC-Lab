# Wazuh Admin Password Reset & Service Restart Guide

This guide will walk you through resetting the Wazuh **admin password** and restarting essential services — all in a secure and beginner-friendly way.

---

## Step 1: Reset the Wazuh Admin Password

To reset the password for the `admin` user (or any other user), run the following command:

```bash
sudo bash /usr/share/wazuh-indexer/plugins/opensearch-security/tools/wazuh-passwords-tool.sh -u admin -p NewSecurePassword123
```

> **Important:** Replace `NewSecurePassword123` with a **strong, secure password** that you’ll remember.

✅ This command securely updates the user’s credentials in the OpenSearch security plugin used by Wazuh.

---

## Step 2: Restart Required Wazuh Services

Once the password is changed, restart the Wazuh services to apply the update:

```bash
sudo systemctl restart filebeat
sudo systemctl restart wazuh-dashboard
sudo systemctl restart Wazuh-manager
```

These commands ensure that all components (Wazuh manager, API, and indexer) reload with the new credentials.

---

## Security Best Practices

Keep your Wazuh deployment secure by following these tips:

* ✅ Use **complex, unique passwords** for all admin users.
* 🔐 Restrict access to this command to **trusted administrators only**.
* 🧠 Don’t share credentials in public or unsecured places.
* 📁 Consider using a **password manager** to store strong credentials safely.

---

## Need Help?

Encountering issues or errors?

* 📩 Open an issue on this repository.
* 💬 Ask in the Wazuh community or your internal team.
* 📘 Refer to the official Wazuh documentation for troubleshooting tips.