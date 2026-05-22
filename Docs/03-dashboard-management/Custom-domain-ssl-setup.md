# How to Set Up a Custom Domain and Let’s Encrypt SSL on Wazuh Dashboard – Step-by-Step HTTPS Guide

### Installing and Configuring the Certbot Client

To secure my Wazuh Dashboard with HTTPS, the first thing I did was install **Certbot**, which makes it easy to get free SSL certificates from Let’s Encrypt.

#### Step 1: Install Snap

I started by installing **snap**, because the Certbot snap ensures I always get the latest version with automatic renewal features:

```bash
apt-get update
apt-get install snap
```

Then, I made sure **snap** itself was up to date:

```bash
snap install core; snap refresh core
```

I saw an output like this, confirming everything was up to date:

```
core 16-2.61.4-20250626 from Canonical✓ installed
snap "core" has no updates available
```

#### Step 2: Install Certbot

Next, I installed **Certbot** using the classic snap:

```bash
snap install --classic certbot
```

### Linking Certbot and Generating Let’s Encrypt SSL Certificate

After installing Certbot, I needed to make it easy to run from anywhere by linking it to my system’s user directory:

```bash
ln -s /snap/bin/certbot /usr/bin/certbot
```

### Opening Ports for HTTP and HTTPS

Before generating the certificate, I made sure ports **80 (HTTP)** and **443 (HTTPS)** were open so Let’s Encrypt could verify my domain:

```bash
ufw allow 443
ufw allow 80
```

### Generating the Let’s Encrypt Certificate

Then, I ran Certbot to generate the SSL certificate for my Wazuh Dashboard domain:

```bash
certbot certonly --standalone -d <YOUR_DOMAIN_NAME>
```

Here’s what the options mean:

* `--standalone`: Certbot temporarily runs its own web server to complete domain verification.
* `-d <YOUR_DOMAIN_NAME>`: Replace `<YOUR_DOMAIN_NAME>` with your actual Fully Qualified Domain Name (FQDN) for the Wazuh Dashboard.

Once it finished, I confirmed the certificates were created:

```bash
ls -la /etc/letsencrypt/live/<YOUR_DOMAIN_NAME>/
```

I saw files like this:

```
cert.pem
chain.pem
fullchain.pem
privkey.pem
README
```

* `README`: Information about the certificate files.
* `privkey.pem`: My private key (keep it secure!).
* `fullchain.pem`: The SSL certificate bundled with all intermediate certificates.

---

### Configuring Let’s Encrypt SSL on Wazuh Dashboard

Next, I copied the certificates to the Wazuh Dashboard directory:

```bash
cp /etc/letsencrypt/live/<YOUR_DOMAIN_NAME>/privkey.pem /etc/letsencrypt/live/<YOUR_DOMAIN_NAME>/fullchain.pem /etc/wazuh-dashboard/certs/
```

Then, I updated the Wazuh Dashboard configuration file to use these new certificates:

```bash
sudo nano /etc/wazuh-dashboard/opensearch_dashboards.yml
```

I added or updated these lines:

```yaml
server.ssl.key: "/etc/wazuh-dashboard/certs/privkey.pem"
server.ssl.certificate: "/etc/wazuh-dashboard/certs/fullchain.pem"
```

After editing, my full configuration looked like this:

```yaml
server.host: 0.0.0.0
opensearch.hosts: https://127.0.0.1:9200
server.port: 443
opensearch.ssl.verificationMode: certificate
opensearch.username: kibanaserver
opensearch.password: kibanaserver
opensearch.requestHeadersWhitelist: ["securitytenant","Authorization"]
opensearch_security.multitenancy.enabled: false
opensearch_security.readonly_mode.roles: ["kibana_read_only"]
server.ssl.enabled: true
server.ssl.key: "/etc/wazuh-dashboard/certs/privkey.pem"
server.ssl.certificate: "/etc/wazuh-dashboard/certs/fullchain.pem"
opensearch.ssl.certificateAuthorities: ["/etc/wazuh-dashboard/certs/root-ca.pem"]
uiSettings.overrides.defaultRoute: /app/wazuh
opensearch_security.cookie.secure: true
```

---

### Securing the Certificates

I made sure the certificates had the correct ownership and permissions:

```bash
chown -R wazuh-dashboard:wazuh-dashboard /etc/wazuh-dashboard/
chmod -R 500 /etc/wazuh-dashboard/certs/
chmod 440 /etc/wazuh-dashboard/certs/privkey.pem /etc/wazuh-dashboard/certs/fullchain.pem
```

---

### Restarting Wazuh Dashboard

Finally, I restarted the Wazuh Dashboard service to apply the SSL configuration:

```bash
systemctl restart wazuh-dashboard
```

Now my Wazuh Dashboard was fully accessible over **HTTPS** using my custom domain with a valid Let’s Encrypt certificate.


### Configuring Automatic Renewal for Let’s Encrypt Certificates

I learned that **Let’s Encrypt certificates are only valid for 90 days**, so it’s important to set up automatic renewal to avoid my Wazuh Dashboard going offline.

Thankfully, the Certbot package I installed already adds a renewal script to `/etc/cron.d`. This script runs **twice a day** and will attempt to renew the certificate **30 days before expiration**.


### Adding a Renewal Hook to Restart Wazuh Dashboard

To make sure the renewed certificate takes effect immediately, I added a **renewal hook** that restarts the Wazuh Dashboard whenever a certificate is renewed.

Here’s how I did it:

1. Open the domain’s renewal configuration file:

```bash
sudo nano /etc/letsencrypt/renewal/<YOUR_DOMAIN_NAME>.conf
```

2. Add or update the following lines at the end of the file:

```ini
renew_before_expiry = 30 days
version = 5.0.0
archive_dir = /etc/letsencrypt/archive/<YOUR_DOMAIN_NAME>
cert = /etc/letsencrypt/live/<YOUR_DOMAIN_NAME>/cert.pem
privkey = /etc/letsencrypt/live/<YOUR_DOMAIN_NAME>/privkey.pem
chain = /etc/letsencrypt/live/<YOUR_DOMAIN_NAME>/chain.pem
fullchain = /etc/letsencrypt/live/<YOUR_DOMAIN_NAME>/fullchain.pem

[renewalparams]
account = pa269247c1c3c97ec12ka01fa0f456bb
authenticator = standalone
server = https://acme-v02.api.letsencrypt.org/directory
key_type = rsa
renew_hook = systemctl restart wazuh-dashboard
```

* The `renew_hook` ensures the Wazuh Dashboard restarts automatically after each certificate renewal.

---

### Testing the Renewal Hook

I wanted to make sure everything worked, so I ran a **dry run** to simulate renewal:

```bash
certbot renew --dry-run
```

The output looked like this:

```
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Processing /etc/letsencrypt/renewal/<YOUR_DOMAIN_NAME>.conf
Simulating renewal of an existing certificate for <YOUR_DOMAIN_NAME>
Congratulations, all simulated renewals succeeded:
/etc/letsencrypt/live/<YOUR_DOMAIN_NAME>/fullchain.pem (success)
```

This confirmed that automatic renewal was set up correctly, and my Wazuh Dashboard would always stay secure with a valid SSL certificate.

Reference: [Wazuh Official Documentation – Configuring Third-Party SSL Certificates](https://documentation.wazuh.com/current/user-manual/wazuh-dashboard/configuring-third-party-certs/ssl.html)