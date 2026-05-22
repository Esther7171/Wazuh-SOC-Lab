# How to Install Wazuh with Docker

This guide provides a **one-shot installation** of Wazuh using Docker on Debian and Ubuntu systems. Follow the steps below to get Wazuh up and running quickly. This is ideal for security analysts, system administrators, or anyone looking to deploy Wazuh for monitoring and security management.

---

## Prerequisites

Before starting, make sure your system meets the following requirements:

- Debian-based system (Debian, Ubuntu)
- Root or sudo privileges
- Internet connection
- Git installed (`sudo apt install git -y`)
- Docker installed (if not, the script will attempt to install it)

---

## Step 1: Clone the Installation Script

Open your terminal and run:

```bash
git clone https://gist.github.com/4a0e3ccec609cd8b8f1ab3b4730951cb.git
cd 4a0e3ccec609cd8b8f1ab3b4730951cb
````

---

## Step 2: Run the Installation Script

Execute the provided script to automatically install Wazuh with Docker:

```bash
sudo bash wazuh-install.sh
```

> ⚠️ Make sure you are running this on a **Debian or Ubuntu system**. Running it on unsupported OS may cause errors.

---

## Step 3: Verify the Installation

Once the script completes:

1. Check Docker containers:

```bash
docker ps
```

You should see Wazuh containers running.

2. Access the Wazuh dashboard:
* Use default credentials (if any) provided by the installation script

