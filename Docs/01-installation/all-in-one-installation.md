# How to Install Wazuh All-in-One

> **Note**
> Root privileges are required to run all commands below.

---

## Overview

This guide explains how to deploy a Wazuh All-in-One setup including:

- Wazuh Server
- Wazuh Indexer
- Wazuh Dashboard

The installation uses the official Wazuh installation assistant.

---

## Install Required Utilities

Install the required packages before starting the deployment.

```bash
sudo apt update
sudo apt install -y curl wget nano
```

---

## Create Installation Directory

Create a dedicated directory to organize the installation files.

```bash
mkdir wazuh-install
cd wazuh-install
```

---

## Download Wazuh Installation Files

Download the Wazuh installation assistant and configuration file.

```bash
curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh
curl -sO https://packages.wazuh.com/4.14/config.yml
```

---

## Configure Wazuh Deployment

Edit the `config.yml` file and update the node names and IP addresses.

```bash
nano config.yml
```

Example configuration:

```yaml
nodes:
  # Wazuh indexer nodes
  indexer:
    - name: node-1
      ip: "10.10.10.10"
    #- name: node-2
    #  ip: "<indexer-node-ip>"
    #- name: node-3
    #  ip: "<indexer-node-ip>"

  # Wazuh server nodes
  server:
    - name: wazuh-1
      ip: "10.10.10.10"
    #  node_type: master
    #- name: wazuh-2
    #  ip: "<wazuh-manager-ip>"
    #  node_type: worker

  # Wazuh dashboard nodes
  dashboard:
    - name: dashboard
      ip: "10.10.10.10"
```

---

## Configure Static Public IP (Optional)

By default, the installer blocks public IP addresses.

If your server uses a static public IP, edit the installation script and comment out or remove the following block:

```bash
for ip in "${all_ips[@]}"; do
    isIP=$(echo "${ip}" | grep -P "^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$")
    if [[ -n "${isIP}" ]]; then
        if ! cert_checkPrivateIp "$ip"; then
            common_logger -e "The IP ${ip} is public."
            exit 1
        fi
    fi
done
```

<div align="center">
  <img src="https://github.com/user-attachments/assets/84040969-831b-414e-8843-5b35dad2308a">
</div>

---

## Start the Installation

Run the following command to install all Wazuh components.

```bash
sudo bash wazuh-install.sh -a
```

### Installation Flag

| Flag | Description |
|---|---|
| `-a` | Installs all Wazuh components |

---

## Access Wazuh Dashboard

After the installation is complete, the installer will display:

- Dashboard URL
- Username
- Password

Use those credentials to log in to the Wazuh dashboard.

---

## Conclusion

You have successfully deployed the Wazuh All-in-One environment.