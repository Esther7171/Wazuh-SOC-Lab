# Installing the wazuh All In One Installation.

> **Note**: You need root user privileges to run all the commands described below.

---

### Download this commond utils:
```
sudo apt -y install curl wget nano
```

### Step 1: Create a Directory for Installtion files.
Organize all installtion files in a dedicated directory:

```bash
mkdir wazuh-install
cd wazuh-install
```

---

### Initail configuration
Set up your deployment configuration, generate SSL certificates, and create secure random passwords.

### Download the Installtion Assitant and Configuration File:

```bash
curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh
curl -sO https://packages.wazuh.com/4.14/config.yml
```
### Edit `config.yml`:
Update the node names and IP addresses for your Wazuh server, indexer, and dashboard. Modify the `nodes` section as needed:
```
nano config.yml
```

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

## Configure for Static Public IP (Optional)
If using a static public IP, modify the script by commenting out or deleting the following block to allow public IP usage:

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
  <img src="https://github.com/user-attachments/assets/84040969-831b-414e-8843-5b35dad2308a"></img>
</div>


---

### Run and Install

```
sudo bash wazuh-install.sh -a 
```

* `-a`: it stand for all.

### After the installtion is complete at the end u will get the id and pass of dashboard.
---
