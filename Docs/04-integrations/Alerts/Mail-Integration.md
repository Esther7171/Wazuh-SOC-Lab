# How to Set Up Wazuh Mail Alerts with SMTP – Step-by-Step Configuration Guide

## Introduction
This guide explains how to configure SMTP settings in Wazuh to enable email alerts for security events. By setting up email notifications, you can receive alerts when specific rules are triggered.

1. Run this command to install the required packages. Select No configuration, if prompted about the mail server configuration type.

```
sudo apt-get update && apt-get install postfix mailutils libsasl2-2 ca-certificates libsasl2-modules
```

<div align=center>
  <img src="https://github.com/user-attachments/assets/882e4fa6-f1ed-49e7-9e06-21013b8dafda"></img>
</div>

2. **Select No Configuration**

3. Append these lines to the `/etc/postfix/main.cf` file to configure Postfix. Create the file if missing.
```
nano /etc/postfix/main.cf
```
```xml
relayhost = [smtp.gmail.com]:587
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
smtp_use_tls = yes
smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, defer_unauth_destination
```

4. **Go to your gmail of the mail you were using and create a [app password](https://myaccount.google.com/apppasswords?pli=1&rapt=AEjHL4Pv1YWpSOoP-tkrnbgDUE9W5MTey-cZBe3kp-DkJV_cK9s7eEbr4kX8OObm7LyNEdsKuGH-1tRVMoTVjIaSMYRs5fp--ojmFZRF0UDKQtR1jvEW0Ps)**

5. Set the credentials of the sender in the `/etc/postfix/sasl_passwd` file and create a database file for Postfix. Replace the <USERNAME> and <PASSWORD> variables with sender’s email address username and password respectively.

```
echo [smtp.gmail.com]:587 <USERNAME>@gmail.com:<PASSWORD> > /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
```

<div align="center">
<img src="https://github.com/user-attachments/assets/1b8b9eaa-ae32-4e7f-b372-a0cbc721226c" height=""></img>
</div>

6. Secure your password DB file so that only the root user has full read and write access to it. This is because the `/etc/postfix/sasl_passwd` and `/etc/postfix/sasl_passwd.db` files have plaintext credentials.

```
chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
```

7. Restart Postfix to effect the configuration changes

```
systemctl restart postfix
```

8. Run the following command to test the configuration

```
echo "Test mail from postfix" | mail -s "Test Postfix" -r "<CONFIGURED_EMAIL>" <RECEIVER_EMAIL>
```

## Alert Management in Wazuh
Wazuh generates alerts based on predefined rules. By default, alerts are stored in:
- `/var/ossec/logs/alerts/alerts.log`
- `/var/ossec/logs/alerts/alerts.json`

To enhance monitoring, you can configure Wazuh to forward alerts via syslog, email, or external databases.

## Configuring Email Alerts
### Step 1: Update Global Email Settings
Edit the Wazuh configuration file located at `/var/ossec/etc/ossec.conf` and add the following configuration under the `<global>` section:

```xml
<ossec_config>
  <global>
    <email_notification>yes</email_notification>
    <email_to>me@test.com</email_to>
    <smtp_server>mail.test.com</smtp_server>
    <email_from>wazuh@test.com</email_from>
  </global>
</ossec_config>
```

### Step 2: Set Alert Level for Emails
Modify the `<alerts>` section in `/var/ossec/etc/ossec.conf` to set the minimum severity level for email alerts:

```xml
<ossec_config>
  <alerts>
    <email_alert_level>10</email_alert_level>
  </alerts>
</ossec_config>
```

The `<email_alert_level>` value determines the minimum alert severity required to trigger an email. The allowed range is from 1 to 16.

## Restarting Wazuh to Apply Changes
After modifying the configuration file, restart the Wazuh manager for the changes to take effect:

```sh
systemctl restart wazuh-manager
```

## Verifying Email Alerts
Once configured, Wazuh will send email notifications when an alert meets the specified threshold. Below is an example of an email notification:

```
Wazuh Notification.
2024 Apr 29 08:58:30

Received From: wazuh-server->syscheck
Rule: 553 fired (level 7) -> "File deleted."
Portion of the log(s):

File '/var/ossec/test_dir/somefile.txt' deleted
Mode: realtime

--END OF NOTIFICATION
```
# ⚡Customize your Email Alerts⚡

1. Go to:

```bash
cd /var/ossec/integrations
```

2. Create the script:

```bash
nano custom-email-alert.py
```

3. Paste the full Python code provided earlier. 
```
#!/usr/bin/env python3
# Authors: esther7171 & yash
# Updated: July 13, 2025
# Purpose: Custom Email Alerts for Wazuh using Postfix (Gmail-compatible)
# License: GNU GPL v2

import json
import sys
import time
import os
import smtplib
from email.utils import formataddr
from email.message import EmailMessage
from json2html import json2html

# ========== SMTP Configuration ==========
email_server = "localhost"
email_port = 25
email_from = "your-alert@gmail.com"  # Must match your authenticated sender (Gmail App Password)
sender_name = "Deathesther Alerting"

# ========== Global Paths ==========
debug_enabled = False
pwd = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
log_file = f'{pwd}/logs/integrations-email.log'
now = time.strftime("%a %b %d %H:%M:%S %Z %Y")

# ========== Logging ==========
def debug(msg):
    if debug_enabled:
        entry = f"{now}: {msg}\n"
        print(entry)
        with open(log_file, "a") as f:
            f.write(entry)

# ========== Email Sender ==========
def send_email(recipients, subject, body):
    try:
        em = EmailMessage()
        em['From'] = formataddr((sender_name, email_from))
        em['To'] = recipients.strip()
        em['Subject'] = subject
        em.set_content(body, subtype='html')

        with smtplib.SMTP(email_server, email_port) as server:
            server.ehlo()
            server.send_message(em)

        debug(f"Email sent to {recipients}")
    except Exception as e:
        debug(f"Email sending failed to {recipients} with error: {e}")

# ========== HTML Generator ==========
def generate_msg(alert):
    try:
        description = alert['rule'].get('description', 'No description')
        level = alert['rule'].get('level', 'N/A')
        agentname = alert['agent'].get('name', 'Unknown')
        timestamp_raw = alert.get('timestamp', '')
        timestamp = time.strftime('%c', time.strptime(timestamp_raw.split('.')[0], '%Y-%m-%dT%H:%M:%S')) if timestamp_raw else 'Unknown'
        full_log = alert.get('full_log', 'No log')

        subject = f'[Esther Alert]: Rule level: [ {level} ], from agent: [ {agentname} ], Description: [ {description} ]'

        msg = f"""
        <html><head>
        <style>
            body {{ font-family: Verdana; }}
            table {{ border-collapse: collapse; width: 100%; }}
            td, th {{ border: 1px solid #ddd; padding: 8px; }}
            th {{ background-color: #38414f; color: white; }}
            .logo {{ text-align: center; }}
            .logo img {{ height: 70px; }}
        </style>
        </head><body>
        <div class="logo">
            <img src="https://yourdomain.com/logo.png" alt="Alert Logo">
        </div>
        <h2>⚠️ Alert from Wazuh</h2>
        <table>
            <tr><th>Date</th><td>{timestamp}</td></tr>
            <tr><th>Agent</th><td>{agentname}</td></tr>
            <tr><th>Rule</th><td>{description}</td></tr>
            <tr><th>Severity</th><td>{level}</td></tr>
            <tr><th>Log</th><td>{full_log}</td></tr>
        </table>
        <hr>
        <h4>🧾 Full Alert JSON:</h4>
        <div>{json2html.convert(json=alert)}</div>
        </body></html>
        """
        return subject, msg
    except Exception as e:
        debug(f"Error generating message: {e}")
        return "Wazuh Alert", f"<pre>{json.dumps(alert, indent=2)}</pre>"

# ========== Main Runner ==========
def main(args):
    if len(args) < 4:
        debug("Error: Not enough arguments. Exiting.")
        sys.exit(1)

    alert_file = args[1]
    recipients = args[3]

    debug(f"Alert file: {alert_file}")
    debug(f"Recipients: {recipients}")

    try:
        with open(alert_file, encoding='utf-8', errors='replace') as af:
            lines = af.readlines()
    except Exception as e:
        debug(f"Failed to read alert file: {e}")
        sys.exit(1)

    for line in lines:
        if line.strip():
            try:
                alert = json.loads(line.strip())
                subject, msg = generate_msg(alert)
                send_email(recipients, subject, msg)
            except json.JSONDecodeError as e:
                debug(f"Invalid JSON line skipped: {e}")

# ========== Entry Point ==========
if __name__ == "__main__":
    try:
        if len(sys.argv) >= 4:
            debug_enabled = (len(sys.argv) > 4 and sys.argv[4] == 'debug')
            with open(log_file, 'a') as logf:
                logf.write(f"{now} {' '.join(sys.argv)}\n")
            main(sys.argv)
        else:
            debug("Invalid arguments.")
            sys.exit(1)
    except Exception as e:
        debug(f"Unhandled exception: {e}")
        raise
```
4. Set permissions and ownership:

```bash
chmod 777 custom-email-alert.py
chown root:wazuh custom-email-alert.py
```

5. Install the required dependency:

```bash
pip install json2html --break-system-packages
```

6. Edit the file to customize:
```
sudo nano custom-email-alert.py
```

![image](https://github.com/user-attachments/assets/413dde07-d01c-4dbd-9659-635db57f43d1)


* `email_server` – your SMTP server IP (or hostname) [your wazuh Server Address]
* `email_from` – email configured in SMTP[mail you config form smtp to send mails.]

### Add Integration to ossec.conf

```bash
nano /var/ossec/etc/ossec.conf
```

Paste the following block under the <ossec_config> root node, preferably inside or after the <alerts> section, as shown in the screenshot below:

```xml
<integration>
  <name>custom-email-alert.py</name>
  <hook_url>receiver-mail@gmail.com</hook_url>
  <level>3</level>
  <alert_format>json</alert_format>
</integration>
```
📌 Best placement: Directly after the <alerts> block for better readability and structure, like this:

![image](https://github.com/user-attachments/assets/3388bace-3b32-4144-a883-476608e88b8b)

This ensures the integration is triggered when alerts of level 3 or higher are generated.

Restart Wazuh:

```bash
sudo systemctl restart wazuh-manager
```

### Test Manually

```bash
./var/ossec/integrations/custom-email-alert.py /var/ossec/logs/alerts/alerts.json dummy your-reciever-mail@gmail.com debug
```

---

## Additional Configurations for Custom Alert

You can further customize the alert appearance and branding:

### ✅ Change Sender Name

Edit:

```python
em['From'] = formataddr(('Deathesther Alerting', email_from))
```

Replace `'Deathesther Alerting'` with your custom name.

---

### ✅ Customize Subject Line

Edit:

```python
subject = f'[Esther Alert]: Rule level: [ {level} ], from agent: [ {agentname} ], Description: [ {description} ]'
```

You can change `[Esther Alert]` to anything else.

---

### ✅ Change Logo

Replace the logo URL in the HTML template:

```html
<img class="logo-image" src="https://yourcompany.com/logo.png" alt="Alert Logo">
```

Make sure the image is accessible via HTTPS and in `.png` or `.jpg` format.

---

## Troubleshooting

| Issue                          | Solution                                                          |
| ------------------------------ | ----------------------------------------------------------------- |
| No email received              | Check Postfix status: `systemctl status postfix`                  |
| Email sent but not received    | Check spam folder or domain restrictions                          |
| Script errors                  | Run with `debug` flag: `./custom-email-alert.py ... debug`        |
| Invalid JSON or no alerts sent | Ensure alert format is `json` and Wazuh rule level matches config |
| Missing module error           | Run `pip install json2html --break-system-packages`               |
| SMTP Timeout or Refused        | Ensure port 25/587 is open and server allows relays for your IP   |
| Wrong From address             | Match `email_from` with authenticated SMTP address                |

---


## Conclusion

By configuring SMTP in Wazuh and adding a custom integration, you can create well-formatted, branded email alerts for improved threat visibility and faster response. This setup provides full flexibility to modify sender names, logos, and subject formats to match your organizational standards.

---

### Reference

* [Wazuh Documentation - Email Alerts](https://documentation.wazuh.com/current/user-manual/manager/alert-management.html#configuring-email-alerts)


