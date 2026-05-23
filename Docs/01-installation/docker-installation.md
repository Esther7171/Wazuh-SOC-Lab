# How to Install Wazuh Using Docker

This guide explains how to deploy Wazuh using Docker on Ubuntu and Debian systems.

The deployment includes:

- Wazuh Manager
- Wazuh Indexer
- Wazuh Dashboard

---

## Requirements

Before starting, make sure your system has:

- Ubuntu or Debian
- Root or sudo privileges
- Internet connection
- Docker installed
- Docker Compose installed
- Git installed

Install Git if needed:

```bash
sudo apt update
sudo apt install git -y
```

---

## Clone the Wazuh Docker Repository

Clone the official Wazuh Docker repository.

```bash
git clone https://github.com/wazuh/wazuh-docker.git -b v4.14.5
```

Move into the single-node deployment directory.

```bash
cd wazuh-docker/single-node
```

---

## Configure Docker Host

Set the required virtual memory value for the Wazuh indexer.

```bash
sudo sysctl -w vm.max_map_count=262144
```

To make it persistent after reboot:

```bash
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

Apply the changes:

```bash
sudo sysctl -p
```

---

## Generate SSL Certificates

Generate self-signed certificates for secure communication.

```bash
docker compose -f generate-indexer-certs.yml run --rm generator
```

---

## Start Wazuh Docker Deployment

Start all Wazuh containers in the background.

```bash
docker compose up -d
```

---

## Verify Running Containers

Check whether all containers are running correctly.

```bash
docker ps
```

You should see containers for:

- Wazuh Manager
- Wazuh Indexer
- Wazuh Dashboard

---

## Access the Wazuh Dashboard

Open your browser and access:

```bash
https://YOUR_SERVER_IP
```

Default credentials:

| Username | Password |
|---|---|
| admin | SecretPassword |

---

## Exposed Ports

| Port | Service |
|---|---|
| 1514 | Wazuh Agent Connection |
| 1515 | Agent Enrollment |
| 55000 | Wazuh API |
| 9200 | Wazuh Indexer |
| 443 | Wazuh Dashboard |

---

## Troubleshooting

### Wazuh Dashboard Not Loading

Check container status:

```bash
docker ps
```

Check logs:

```bash
docker logs wazuh.dashboard
```

---

### Indexer Failed to Start

Verify memory configuration:

```bash
sysctl vm.max_map_count
```

The value should be:

```bash
262144
```

---

## Conclusion

You have successfully deployed Wazuh using Docker.