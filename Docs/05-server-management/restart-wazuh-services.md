# Restarting Wazuh Services Using a Custom Script

This guide explains how to create a custom script to quickly restart all Wazuh services.

---

## Create the Restart Script

Create a new script file:

```bash
sudo nano /usr/local/bin/restart-wazuh
```

---

## Add the Script Content

Paste the following script:

```bash
#!/bin/bash

echo "Restarting Wazuh Indexer..."
sudo systemctl restart wazuh-indexer

echo "Restarting Wazuh Manager..."
sudo systemctl restart wazuh-manager

echo "Restarting Filebeat..."
sudo systemctl restart filebeat

echo "Restarting Wazuh Dashboard..."
sudo systemctl restart wazuh-dashboard

echo "Restarting SSH Service..."
sudo systemctl restart ssh

echo "All Wazuh services restarted successfully."
```

---

## Save the Script

Save the file using:

```bash
CTRL + X
```

Then press:

```bash
Y
```

Press:

```bash
ENTER
```

---

## Give Execute Permission

Make the script executable:

```bash
sudo chmod +x /usr/local/bin/restart-wazuh
```

---

## Run the Script

Restart all Wazuh services anytime using:

```bash
sudo restart-wazuh
```

---

## Verify Service Status

Check whether all services are running correctly:

```bash
sudo systemctl status wazuh-manager
```

---

## Conclusion

You have successfully created a custom script to restart Wazuh services quickly.