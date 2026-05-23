## Criminal IP Integration with Wazuh

Criminal IP is a powerful threat intelligence platform that provides in-depth insights into IP addresses, domains, and various network components. By leveraging its capabilities, security teams can proactively assess risks and identify potential threats. Integrating Wazuh with Criminal IP enhances security monitoring, network management, and system administration, providing a comprehensive defense mechanism against cyber threats.

This guide outlines the step-by-step process to integrate Criminal IP with Wazuh for enhanced threat detection and mitigation.

### Key Features
This integration enables tracking of:
- VPN usage detection
- TOR network usage
- Proxy server usage
- Dark web activity

### Criminal IP Setup
1. **Log in** to your [Criminal IP account](https://www.criminalip.io/login?h2=%2F) and generate your API key.

![criminal-ip-account](https://github.com/user-attachments/assets/f9b7b1fc-4d2b-40ca-beb7-b02b839a61ef)

2. Navigate to **My Information** from the top-right dropdown menu.

![criminal-ip-information](https://github.com/user-attachments/assets/e7b1d4c6-20f4-4e19-9cad-6af03fde3293)

3. **Copy and save** your generated API key for later use.

![criminal-ip-api-key](https://github.com/user-attachments/assets/9fd6c216-667e-48b6-9b2b-2a4d9595257b)


> **Note:** Free Criminal IP membership includes 50 free credits for IP address lookup. Upgrade to a premium plan for higher usage.

### Wazuh Server Configuration
#### 1. Create the Integration Script
1. **Create a script file** at `/var/ossec/integrations/custom-criminalip.py`:
   ```sh
   sudo nano /var/ossec/integrations/custom-criminalip.py
   ```
2. **Paste the following Python script:**

```py
#!/var/ossec/framework/python/bin/python3

import sys
import os
import json
import ipaddress
import requests
from requests.exceptions import ConnectionError, HTTPError
from socket import socket, AF_UNIX, SOCK_DGRAM
import time

# Enable or disable debugging
debug_enabled = True  # Set to False to disable debug logging

# File and socket paths
pwd = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
socket_addr = f'{pwd}/queue/sockets/queue'

# Set paths for logging
now = time.strftime("%a %b %d %H:%M:%S %Z %Y")
log_file = f'{pwd}/logs/integrations.log'


def debug(msg):
    """Log debug messages."""
    if debug_enabled:
        timestamped_msg = f"{now}: {msg}\n"
        print(timestamped_msg)
        with open(log_file, "a") as f:
            f.write(timestamped_msg)


def send_event(msg, agent=None):
    """Send an event to the Wazuh Manager."""
    try:
        if not agent or agent["id"] == "000":
            string = f'1:criminalip:{json.dumps(msg)}'
        else:
            string = f'1:[{agent["id"]}] ({agent["name"]}) {agent["ip"] if "ip" in agent else "any"}->criminalip:{json.dumps(msg)}'
        
        debug(f"Sending Event: {string}")
        with socket(AF_UNIX, SOCK_DGRAM) as sock:
            sock.connect(socket_addr)
            sock.send(string.encode())
    except Exception as e:
        debug(f"Error sending event: {e}")


# Read configuration parameters
try:
    alert_file = open(sys.argv[1])
    alert = json.loads(alert_file.read())
    alert_file.close()
    debug("Alert loaded successfully")
except Exception as e:
    debug(f"Error reading alert file: {e}")
    sys.exit(1)

# New Alert Output for CriminalIP Alert or Error calling the API
alert_output = {}

# Criminal IP API AUTH KEY
criminalip_api_key = sys.argv[2]

# API - HTTP Headers
criminalip_apicall_headers = {
    "x-api-key": f"{criminalip_api_key}"
}

# Extract Event Source
try:
    event_source = alert["rule"]["groups"]
    debug(f"Event source: {event_source}")
except KeyError as e:
    debug(f"Missing expected key in alert: {e}")
    sys.exit(1)

if any(group in ['web', 'sshd', 'invalid_login', 'firewall', 'ids', 'system', 'database', 'application'] for group in event_source):
    try:
        client_ip = alert["data"]["srcip"]  # Extract client IP
        debug(f"Extracted Client IP: {client_ip}")
        if ipaddress.ip_address(client_ip).is_global:
            # Pass the client_ip value directly into the URL
            criminalip_search_url = f'https://api.criminalip.io/v1/asset/ip/report?ip={client_ip}&full=true'
            debug(f"CriminalIP API URL: {criminalip_search_url}")
            try:
                criminalip_api_response = requests.get(criminalip_search_url, headers=criminalip_apicall_headers)
                criminalip_api_response.raise_for_status()  # Raise HTTPError for bad responses
                debug("API request successful")
            except ConnectionError as conn_err:
                alert_output["criminalip"] = {"error": 'Connection Error to CriminalIP API'}
                alert_output["integration"] = "criminalip"
                debug(f"ConnectionError: {conn_err}")
                send_event(alert_output, alert.get("agent"))
            except HTTPError as http_err:
                alert_output["criminalip"] = {"error": f'HTTP Error: {http_err}'}
                alert_output["integration"] = "criminalip"
                debug(f"HTTPError: {http_err}")
                send_event(alert_output, alert.get("agent"))
            except Exception as e:
                alert_output["criminalip"] = {"error": f'Unexpected Error: {e}'}
                alert_output["integration"] = "criminalip"
                debug(f"Unexpected Error: {e}")
                send_event(alert_output, alert.get("agent"))
            else:
                try:
                    criminalip_api_response = criminalip_api_response.json()
                    debug(f"API Response Data: {criminalip_api_response}")
                    # Check if the response contains score information
                    if "score" in criminalip_api_response and criminalip_api_response["score"]:
                        # Generate Alert Output from CriminalIP Response
                        score = criminalip_api_response["score"]
                        issues = criminalip_api_response["issues"]
                        alert_output["criminalip"] = {
                            "ip": criminalip_api_response["ip"],
                            "score_inbound": score.get("inbound", "Unknown"),
                            "score_outbound": score.get("outbound", "Unknown"),
                            "is_vpn": issues.get("is_vpn", False),
                            "is_tor": issues.get("is_tor", False),
                            "is_proxy": issues.get("is_proxy", False),
                            "is_cloud": issues.get("is_cloud", False),
                            "is_hosting": issues.get("is_hosting", False),
                            "is_darkweb": issues.get("is_darkweb", False),
                            "is_scanner": issues.get("is_scanner", False),
                            "is_snort": issues.get("is_snort", False),
                            "is_anonymous_vpn": issues.get("is_anonymous_vpn", False)
                        }
                        alert_output["integration"] = "criminalip"
                        debug(f"Alert Output: {alert_output}")
                        send_event(alert_output, alert.get("agent"))
                    else:
                        alert_output["criminalip"] = {"error": 'No score information found in CriminalIP response'}
                        alert_output["integration"] = "criminalip"
                        debug("No score information found in CriminalIP response")
                        send_event(alert_output, alert.get("agent"))
                except Exception as e:
                    alert_output["criminalip"] = {"error": f"Error parsing JSON response: {e}"}
                    alert_output["integration"] = "criminalip"
                    debug(f"Error parsing JSON response: {e}")
                    send_event(alert_output, alert.get("agent"))
        else:
            debug(f"Client IP is not global: {client_ip}")
            sys.exit()
    except KeyError as e:
        alert_output["criminalip"] = {"error": f'Missing expected key: {e}'}
        alert_output["integration"] = "criminalip"
        debug(f"KeyError: {e}")
        send_event(alert_output, alert.get("agent"))
        sys.exit()
else:
    debug(f"Event source is not found : {event_source}")
    sys.exit()
    ```
3. **Set proper permissions** for the script:
```
3. **Set proper permissions** for the integrations script:
```sh
  chmod 750 /var/ossec/integrations/custom-criminalip.py
  chown root:wazuh /var/ossec/integrations/custom-criminalip.py
```

#### 2. Configure Wazuh to Use the Script
1. **Edit the Wazuh configuration file** (`/var/ossec/etc/ossec.conf`) and add:
```sh
sudo nano /var/ossec/etc/ossec.conf
```
   ```xml
   <ossec_config>
     <integration>
       <name>custom-criminalip.py</name>
       <api_key><CRIMINALIP_API_KEY></api_key>
       <group>web, sshd, invalid_login, firewall, ids, system, database, application</group>
       <alert_format>json</alert_format>
     </integration>
   </ossec_config>
   ```

#### 3. Create Custom Rules
1. **Create a new ruleset file** at `/var/ossec/etc/rules/criminal_ip_ruleset.xml`:
   ```sh
   sudo nano /var/ossec/etc/rules/criminal_ip_ruleset.xml
   ```
2. **Paste the rule definitions:**

```xml
<group name="criminalip,">


  <!-- Main Criminal IP Rule -->

  <rule id="100623" level="2">
    <decoded_as>json</decoded_as>
    <field name="integration">criminalip</field>
    <description>Criminal IP Events</description>
  </rule>


  <!-- VPN Detection Rule -->

  <rule id="100624" level="6">
    <if_sid>100623</if_sid>
    <field name="criminalip.is_vpn">true</field>
    <description>IP address associated with a VPN service detected: $(criminalip.ip)</description>
  </rule>


  <!-- TOR Detection Rule -->

  <rule id="100625" level="10">
    <if_sid>100623</if_sid>
    <field name="criminalip.is_tor">true</field>
    <description>IP address associated with TOR network detected: $(criminalip.ip)</description>
  </rule>


  <!-- Proxy Detection Rule -->

  <rule id="100626" level="5">
    <if_sid>100623</if_sid>
    <field name="criminalip.is_proxy">true</field>
    <description>IP address associated with a Proxy server detected: $(criminalip.ip)</description>
  </rule>


  <!-- Dark Web Activity Rule -->

  <rule id="100627" level="8">
    <if_sid>100623</if_sid>
    <field name="criminalip.is_darkweb">true</field>
    <description>IP address associated with Dark web activity detected: $(criminalip.ip)</description>
  </rule>


  <!-- Critical Score Rule -->

  <rule id="100628" level="8">
    <if_sid>100623</if_sid>
    <field name="criminalip.score_inbound">Critical</field>
    <description>Critical risk score for IP address: $(criminalip.ip)</description>
  </rule>


  <!-- Dangerous Score Rule -->

  <rule id="100629" level="9">
    <if_sid>100623</if_sid>
    <field name="criminalip.score_inbound">Dangerous</field>
    <description>Dangerous risk score for IP address: $(criminalip.ip)</description>
  </rule>


  <!-- Moderate Score Rule -->

  <rule id="100630" level="6">
    <if_sid>100623</if_sid>
    <field name="criminalip.score_inbound">Moderate</field>
    <description>Moderate risk score for IP address: $(criminalip.ip)</description>
  </rule>


  <!-- Low Score Rule -->

  <rule id="100631" level="3">
    <if_sid>100623</if_sid>
    <field name="criminalip.score_inbound">Low</field>
    <description>Low risk score for IP address: $(criminalip.ip)</description>
  </rule>



  <!-- Hosting Detection Rule -->

  <rule id="100633" level="5">
    <if_sid>100623</if_sid>
    <field name="criminalip.is_hosting">true</field>
    <description>IP address associated with a Hosting service detected: $(criminalip.ip)</description>
  </rule>


  <!-- Cloud Service Detection Rule -->

  <rule id="100634" level="4">
    <if_sid>100623</if_sid>
    <field name="criminalip.is_cloud">true</field>
    <description>IP address associated with Cloud service detected : $(criminalip.ip)</description>
  </rule>


  <!-- Scanner Activity Detection Rule -->

  <rule id="100636" level="7">
    <if_sid>100623</if_sid>
    <field name="criminalip.is_scanner">true</field>
    <description>IP address associated with scanner activity detected: $(criminalip.ip)</description>
  </rule>

<!-- Mobile Network Detection Rule, This rule may cause high false positives and can be uncommented based on user preference 

  <rule id="100637" level="4">
    <if_sid>100623</if_sid>
    <field name="criminalip.is_mobile">true</field>
    <description>IP address associated with a Mobile network detected: $(criminalip.ip)</description>
  </rule>

 -->

  <!-- Anonymous VPN Detection Rule -->

  <rule id="100638" level="5">
    <if_sid>100623</if_sid>
    <field name="criminalip.is_anonymous_vpn">true</field>
    <description>IP address associated with an Anonymous VPN detected: $(criminalip.ip)</description>
  </rule>


  <!-- Error: Missing Parameter -->

  <rule id="100640" level="5">
    <if_sid>100623</if_sid>
    <field name="full_log">.*Missing Parameter.*</field>
    <description>CriminalIP API error: Missing parameter in request</description>
  </rule>


  <!-- Error: Invalid IP Address -->

  <rule id="100641" level="5">
    <if_sid>100623</if_sid>
    <field name="full_log">.*Invalid IP Address.*</field>
    <description>CriminalIP API error: Invalid IP address format</description>
  </rule>


  <!-- Error: Internal Server Error -->

  <rule id="100642" level="7">
    <if_sid>100623</if_sid>
    <field name="full_log">.*Internal Server Error.*</field>
    <description>CriminalIP API error: Internal server error encountered</description>
  </rule>


</group>
```


#### Where: 

* Rule `100623` is triggered when events associated with Criminal IP integration are observed, filtering logs related to the Criminal IP integration for further analysis.
* Rule `100624` is triggered when IP addresses associated with VPN usage are detected, indicating potential obfuscation of traffic origin.
* Rule `100625` is triggered when IP addresses associated with TOR network usage are observed, often linked with anonymized or malicious activity.
* Rule `100626` is triggered when IP addresses associated with proxy server usage are observed, suggesting attempts to hide the real source of traffic.
* Rule `100627` is triggered when IP addresses linked to dark web activity are observed, which may indicate malicious or illicit actions.
* Rule `100628` is triggered when critical risk scores assigned by Criminal IP are observed, highlighting IP addresses that require immediate attention.
* Rule `100629` is triggered when dangerous risk scores from Criminal IP are observed, marking IPs as potential threats that need closer monitoring.
* Rule `100630` is triggered when moderate risk scores from Criminal IP are observed, indicating threats that are worthy of attention but not urgent.
* Rule `100631` is triggered when low-risk scores from Criminal IP are observed, suggesting minimal threats but still worth monitoring.
* Rule `100633` is triggered when IP addresses associated with a hosting service are observed.
* Rule `100634` is triggered when cloud service usage linked to an IP address is observed, which could be used to host attacks or compromised activities.
* Rule `100636` is triggered when scanner activity is observed, which may indicate vulnerability scanning or reconnaissance.
* Rule `100637` is triggered when an IP address associated with mobile network usage is observed, often linked to mobile-specific threats or targeted attacks.
* Rule `100638` is triggered when  IP addresses associated with anonymous VPN usage are observed, which is commonly used to mask malicious activities.
* Rule `100640` is triggered when missing parameters in requests to the Criminal IP API are observed, raising an alert for errors.
* Rule `100641` is triggered when invalid IP address format errors in the Criminal IP API occur.
* Rule `100642` is triggered when internal server errors in the Criminal IP API are detected, which could indicate issues with the API’s processing capabilities.


3. **Set proper permissions** for the ruleset:
   ```sh
   chmod 660 /var/ossec/etc/rules/criminal_ip_ruleset.xml
   chown wazuh:wazuh /var/ossec/etc/rules/criminal_ip_ruleset.xml
   ```

#### 4. Restart Wazuh Manager
```sh
systemctl restart wazuh-manager
```

By following these steps, Wazuh will be able to query Criminal IP for intelligence on suspicious IP addresses and enrich its alerts with additional threat intelligence.

****
