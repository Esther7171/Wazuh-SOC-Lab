# 🎨 Wazuh Dashboard Custom Branding & Rebranding Guide

Want to give your Wazuh dashboard a personal or organizational touch? Whether you’re adding your company’s logo, updating the background, or customizing the dashboard title, this step-by-step guide walks beginners through the process.

---

# 1. Change the Wazuh Dashboard Logo

<div align="center">
<img src="https://github.com/user-attachments/assets/e3b60358-9e12-49d6-899d-9e4cd32a6c65" img/>
</div>

### 🔍 Location of Logo File

Navigate to the folder where the Wazuh dashboard logos are stored:

```bash
cd /usr/share/wazuh-dashboard/plugins/securityDashboards/target/public
```

Inside this folder, you'll find a random-looking filename like:

```bash
30e500f584235c2912f16c790345f966.svg
```

That’s your **current Wazuh logo** in `.svg` format.

---

### Step 1: Backup the Original Logo

Always make a backup before replacing:

```bash
mv 30e500f584235c2912f16c790345f966.svg 30e500f584235c2912f16c790345f966.svg.bak
```
---

### Step 2: Download and Replace with Your Logo

Use `wget` to download your own logo (in SVG format):

```bash
wget https://yourdomain.com/your-logo.svg
```

Then rename it to match the original filename:

```bash
mv BERSERK-LOGO.svg 30e500f584235c2912f16c790345f966.svg
```

✅ Done! Your new logo will now appear on the dashboard.

<div align="center">
<img src="https://github.com/user-attachments/assets/87361985-3f81-4552-9e12-53eb5435f995" img/>
</div>
poc...

---

# 2. Change the Login Background Image

### 📂 File Location:

```bash
cd /usr/share/wazuh-dashboard/src/core/server/core_app/assets
```

Look for the file:

```bash
wazuh_login_bg.svg
```

###  Backup the Old Background

```bash
mv wazuh_login_bg.svg wazuh_login_bg.svg.bak
```

### Replace with Your Image

Download or create your own SVG image and rename it:

```bash
mv your-background.svg wazuh_login_bg.svg
```

Your login background is now updated!

<div align="center">
<img src="https://github.com/user-attachments/assets/1d8a68dd-c89c-443e-a823-641046e1620e" img/>
</div>
poc...

---

# 3. Add HealthCheck, App & Report logo

#### 1. Open the **Wazuh Dashboard**.

<div align="center">
<img src="https://github.com/user-attachments/assets/c13e1781-28b3-4bef-8a55-d6a50f24c812" img/>
</div>

#### 2. Click the **☰ menu** → **Dashboard Management** → **App Settings**.
* You can use the search filter or scroll down manually to find the settings.

<div align="center">
<img src="https://github.com/user-attachments/assets/68e54785-abca-42be-b81a-9df9cb29fe48" img/>
</div>

#### 3. Upload the logo and images

<div align="center">
<img src="https://github.com/user-attachments/assets/f0f335ac-60e5-407e-9af2-975af1f37106" img/>
</div>

#### save chnage at bottom 

![image](https://github.com/user-attachments/assets/d455ec83-5327-4cf7-b61e-4d710d3a7297)

#### 4. Scroll down and **Save changes**.

✅ Your plugin loading screen is now customized.

---

# 4. Change Favicon (Browser Tab Icon)

### 📂 Location of Favicon Files:

```bash
cd /usr/share/wazuh-dashboard/src/core/server/core_app/assets/favicons
```

### Backup Existing Favicons

```bash
mkdir ../old-favicons
mv * ../old-favicons/
```

### Add Your Custom Favicons

Paste your new `.ico` or `.png` favicon files in the `favicons` folder.
```
/usr/share/wazuh-dashboard/src/core/server/core_app/assets/favicons
```
---

# 5. Configure Custom Branding via Config File

### 📁 Open Configuration File:

```bash
sudo nano /etc/wazuh-dashboard/opensearch_dashboards.yml
```

* For Docker installations.
```bash
/usr/share/wazuh-dashboard/config/
```

## 📝 Change Page Title 

To change the title text shown in your browser add this line:

```yaml
opensearchDashboards.branding.applicationTitle: "Your Company Name"
```

<div align="center">
<img src="https://github.com/user-attachments/assets/926ed4f9-815d-4bba-a8ba-102bea647562" img/>
</div>

## Add Mark, Logo & Loading Screen Links

You can upload logos to [Imgur](https://imgur.com/) or host them yourself, then paste the URLs here:

```yaml
opensearch_security.ui.basicauth.login.brandimage: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"

opensearchDashboards.branding:
  logo:
    defaultUrl: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
    darkModeUrl: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
  loadingLogo:
    defaultUrl: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
    darkModeUrl: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
  mark:
    defaultUrl: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
    darkModeUrl: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
```

---

## Restart Dashboard Service

After any branding update, restart the Wazuh dashboard to apply changes:

```bash
sudo systemctl restart wazuh-dashboard
```
### Example Logo Branding Snippet

```yml
root@server:/etc/wazuh-dashboard# cat -n opensearch_dashboards.yml
     1  server.port: 443
     2  opensearch.ssl.verificationMode: certificate
     3  # opensearch.username: kibanaserver
     4  # opensearch.password: kibanaserver
     5  opensearch.requestHeadersAllowlist: ["securitytenant","Authorization"]
     6  opensearch_security.multitenancy.enabled: true
     7  opensearch_security.auth.multiple_auth_enabled: true
     8  opensearch_security.readonly_mode.roles: ["kibana_read_only"]
     9  server.ssl.enabled: true
    10  server.ssl.key: "/etc/wazuh-dashboard/certs/privkey.pem"
    11  server.ssl.certificate: "/etc/wazuh-dashboard/certs/fullchain.pem"
    12  opensearch.ssl.certificateAuthorities: ["/etc/wazuh-dashboard/certs/root-ca.pem"]
    13  uiSettings.overrides.defaultRoute: /app/wz-home
    14  opensearch_security.cookie.secure: true
    15  server.host: 10.10.10.10
    16  opensearch.hosts: https://10.10.10.10:9200
    17  opensearchDashboards.branding.applicationTitle: 'YourTitle'
    18
    19  opensearch_security.ui.basicauth.login.brandimage: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
    20
    21  opensearchDashboards.branding:
    22    logo:
    23      defaultUrl: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
    24      darkModeUrl: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
    25    loadingLogo:
    26      defaultUrl: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
    27      darkModeUrl: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
    28    mark:
    29      defaultUrl: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
    30      darkModeUrl: "https://www.elirodrigues.com/wp-content/uploads/2016/11/sample-logo-black.png"
```
