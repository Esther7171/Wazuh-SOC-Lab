# Integrating Microsoft Teams with Wazuh Alerts
```
nano custom-teams
```
```bash
#!/bin/sh

WPYTHON_BIN="framework/python/bin/python3"

SCRIPT_PATH_NAME="$0"

DIR_NAME="$(cd $(dirname ${SCRIPT_PATH_NAME}); pwd -P)"
SCRIPT_NAME="$(basename ${SCRIPT_PATH_NAME})"

case ${DIR_NAME} in
    */active-response/bin | */wodles*)
        if [ -z "${WAZUH_PATH}" ]; then
            WAZUH_PATH="$(cd ${DIR_NAME}/../..; pwd)"
        fi

        PYTHON_SCRIPT="${DIR_NAME}/${SCRIPT_NAME}.py"
    ;;
    */bin)
        if [ -z "${WAZUH_PATH}" ]; then
            WAZUH_PATH="$(cd ${DIR_NAME}/..; pwd)"
        fi

        PYTHON_SCRIPT="${WAZUH_PATH}/framework/scripts/${SCRIPT_NAME}.py"
    ;;
     */integrations)
        if [ -z "${WAZUH_PATH}" ]; then
            WAZUH_PATH="$(cd ${DIR_NAME}/..; pwd)"
        fi

        PYTHON_SCRIPT="${DIR_NAME}/${SCRIPT_NAME}.py"
    ;;
esac


${WAZUH_PATH}/${WPYTHON_BIN} ${PYTHON_SCRIPT} "$@"
```
```
nano custom-teams.py
```

```py
#!/usr/bin/env python3

import sys
import json
import logging
import os
import urllib3
import ssl
from datetime import datetime

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Exception for webhook issues
class TeamsWebhookException(Exception):
    pass

# ConnectorCard class for sending messages
class ConnectorCard:
    def __init__(self, hookurl, payload, http_timeout=60):
        self.hookurl = hookurl
        self.payload = payload
        self.http = urllib3.PoolManager(cert_reqs=ssl.CERT_NONE)
        self.http_timeout = http_timeout

    def send(self):
        headers = {"Content-Type": "application/json"}
        response = self.http.request(
            "POST",
            self.hookurl,
            body=json.dumps(self.payload).encode("utf-8"),
            headers=headers,
            timeout=self.http_timeout
        )
        if response.status == 200:
            now = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
            logging.info("Alert sent to Microsoft Teams at %s", now)
            return True
        else:
            logging.fatal("Failed to send alert: %s", response.reason)
            raise TeamsWebhookException(response.reason)

# Enable debug logging if specified
DEBUG = "DEBUG" in sys.argv

log_file = "/var/ossec/logs/microsoft-teams.log"
if DEBUG:
    logging.basicConfig(level=logging.DEBUG, handlers=[logging.StreamHandler()])
else:
    if not os.path.exists(log_file):
        open(log_file, "w+").close()
    logging.basicConfig(filename=log_file, level=logging.INFO)

# Main execution
try:
    logging.debug("Starting Microsoft Teams alert script")

    alert_file_path = sys.argv[1]
    webhook_url = sys.argv[3]

    with open(alert_file_path, 'r') as alert_file:
        alert = json.load(alert_file)

    logging.debug("Parsed alert JSON: %s", json.dumps(alert, indent=2))

    # Extract relevant data with fallbacks
    agent_name = alert.get("agent", {}).get("name", "N/A")
    agent_id = alert.get("agent", {}).get("id", "N/A")
    agent_ip = alert.get("agent", {}).get("ip", "N/A")
    alert_level = str(alert.get("rule", {}).get("level", "N/A"))
    rule_id = str(alert.get("rule", {}).get("id", "N/A"))
    description = alert.get("rule", {}).get("description", "N/A")
    timestamp = alert.get("timestamp", "N/A")

    # Build Teams Adaptive Card payload
    payload = {
        "type": "message",
        "attachments": [
            {
                "contentType": "application/vnd.microsoft.card.adaptive",
                "contentUrl": "",
                "content": {
                    "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                    "type": "AdaptiveCard",
                    "version": "1.5",
                    "body": [
                        {
                            "type": "TextBlock",
                            "size": "Large",
                            "weight": "Bolder",
                            "color": "Attention",
                            "text": "🚨 Wazuh Alert"
                        },
                        {
                            "type": "FactSet",
                            "facts": [
                                {"title": "Agent Name", "value": agent_name},
                                {"title": "Agent ID", "value": agent_id},
                                {"title": "Agent IP", "value": agent_ip},
                                {"title": "Alert Level", "value": alert_level},
                                {"title": "Rule ID", "value": rule_id},
                                {"title": "Description", "value": description},
                                {"title": "Timestamp", "value": timestamp}
                            ]
                        }
                    ]
                }
            }
        ]
    }

    # Send alert to Microsoft Teams
    teams_message = ConnectorCard(webhook_url, payload)
    teams_message.send()

except Exception as e:
    logging.exception("An error occurred while sending the alert: %s", e)
    sys.exit(1)
```

Test
```
nano test.sh
```

```
#!/bin/bash

## Edit the values and run the script to test your teams webhook

webhookUrl=""

python3 custom-teams.py "example-alert.json" "" "${webhookUrl}" " > /dev/null 2>&1" "DEBUG"
```

Where to place
```
chmod 750 /var/ossec/integrations/custom-teams
chown root:wazuh /var/ossec/integrations/custom-teams
chmod 750 /var/ossec/integrations/custom-teams.py
chown root:wazuh /var/ossec/integrations/custom-teams.py
```
Ossec
```
<integration>
  <name>custom-teams</name>
  <level>3</level>
  <hook_url>WEBHOOK URL</hook_url> 
  <alert_format>json</alert_format> 
</integration>
```
