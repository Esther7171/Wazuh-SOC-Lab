# Linux Server Hardening Guide

## 1. Change Passwords:

Use different passwords for the `/root` user and regular sudo users.

### Change the root user password:
```bash
sudo passwd root
```

### Change the current user's password:
```bash
sudo passwd $USER
```

---

## 2. Configure SSH Key-Based Authentication

Using SSH keys for authentication is more secure than password-based logins.

### Clean and Set Up SSH Directory:
```bash
rm -rf ~/.ssh && mkdir ~/.ssh && chmod 700 ~/.ssh
```

### Generate an SSH Key Pair
Use a terminal (Windows PowerShell, macOS, or Linux) to generate a key pair. Specify a longer key length for better security:
```bash
ssh-keygen -b 4096
```

Locate the `id_rsa.pub` file (public key), then upload it to your Linux server.

#### **For Windows (PowerShell):**
```bash
scp $env:USERPROFILE/.ssh/id_rsa.pub linux@10.10.10.10:~/.ssh/authorized_keys
```

#### **For Linux:**
```bash
ssh-copy-id linux@10.10.10.10
```

#### **For macOS:**
```bash
scp ~/.ssh/id_rsa.pub linux@10.10.10.10:~/.ssh/authorized_keys
```

---

## 3. Secure SSH Configuration

Modify the SSH daemon configuration to enhance security.

### Edit the SSH Configuration File:
```bash
sudo nano /etc/ssh/sshd_config
```

#### Key Settings to Update:
1. **Change the Default SSH Port** (e.g., `2000`):
   ```plaintext
   Port 2000
   ```

2. **Restrict Address Family to IPv4 (Optional):**
   ```plaintext
   AddressFamily inet
   ```

3. **Disable Root Login:**
   Search for `PermitRootLogin` and set it to `no`:
   ```plaintext
   PermitRootLogin no
   ```

4. **Disable Password Authentication:**  
   Only allow login using SSH keys:
   ```plaintext
   PasswordAuthentication no
   ```

### Restart the SSH Service:
```bash
systemctl daemon-reload
systemctl restart ssh.socket
```

### Test SSH Access:
```bash
ssh linux@10.10.10.10 -p 2000
```

---

## 4. Configure the Firewall

Use the `ufw` firewall to manage incoming connections.

### Check Existing Allowed Connections:
```bash
sudo ss -tupln
```

### Enable and Configure UFW:
1. Check the status of `ufw`:
   ```bash
   sudo ufw status
   ```

2. Allow the custom SSH port:
   ```bash
   sudo ufw allow 2000
   ```

3. Enable `ufw`:
   ```bash
   sudo ufw enable
   ```

### Disable ICMP (Ping) Requests:
1. Edit the `before.rules` file:
   ```bash
   sudo nano /etc/ufw/before.rules
   ```

2. Locate the line containing `# ok icmp code for INPUT`, then add the following rule to drop ICMP echo requests:
   ```plaintext
   -A ufw-before-input -p icmp --icmp-type echo-request -j DROP
   ```

3. Restart the firewall:
   ```bash
   sudo ufw reload
   ```
## POC 

### Attacking With hydra
<div align="center">
<img src="https://github.com/user-attachments/assets/a00f6f18-1f94-4c52-9835-5b57c0ac9c7f" height=""></img>
</div>

---

This guide helps secure your Linux server by implementing SSH key-based authentication, disabling root and password logins, and configuring the firewall.
