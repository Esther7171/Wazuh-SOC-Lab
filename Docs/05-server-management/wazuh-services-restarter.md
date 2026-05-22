```
sudo nano /usr/local/bin/crow
```
```
#!/bin/bash

echo -e "\033[38;5;201m ________________________\033[0m"
echo -e "\033[38;5;201m< Starting Wazuh Indexer >\033[0m"
echo -e "\033[38;5;201m ------------------------\033[0m"
echo -e "\033[38;5;200m    \\ \033[0m"
echo -e "\033[38;5;198m     \\ \033[0m"
echo -e "\033[38;5;129m                                   .::!!!!!!!:.\033[0m"
echo -e "\033[38;5;129m  .!!!!!:.                        .:!!!!!!!!!!!!\033[0m"
echo -e "\033[38;5;135m  ~~~~!!!!!!.                 .:!!!!!!!!!UWWW\$\$\$\033[0m"
echo -e "\033[38;5;135m      :\$\$NWX!!:           .:!!!!!!XUWW\$\$\$\$\$\$\$\$\$P\033[0m"
echo -e "\033[38;5;141m      \$\$\$\$\$\#WX!:      .<!!!!UW\$\$\$\$\"  \$\$\$\$\$\$\$\$#\033[0m"
echo -e "\033[38;5;165m      \$\$\$\$\$  \$\$\$UX   :!!UW\$\$\$\$\$\$\$\$\$   4\$\$\$\$\$*\033[0m"
echo -e "\033[38;5;171m      ^\$\$\$B  \$\$\$\$\\     \$\$\$\$\$\$\$\$\$\$\$\$   d\$\$R\"\033[0m"
echo -e "\033[38;5;177m        \"*\$bd\$\$\$\$      '*\$\$\$\$\$\$\$\$\$\$\$\$o+#\"\033[0m"
echo -e "\033[38;5;183m             \"\"\"\"          \"\"\"\"\"\"\"\033[0m"

sudo systemctl daemon-reload
sudo systemctl enable wazuh-indexer
sudo systemctl start wazuh-indexer

echo -e "\033[38;5;46m ________________________\033[0m"
echo -e "\033[38;5;82m< Starting Wazuh Manager >\033[0m"
echo -e "\033[38;5;118m ------------------------\033[0m"
echo -e "\033[38;5;154m   \\         ,        ,\033[0m"
echo -e "\033[38;5;154m    \\       /(        )\`\033[0m"
echo -e "\033[38;5;154m     \\      \\ \\___   / |\033[0m"
echo -e "\033[38;5;154m            /- _  \`-/  '\033[0m"
echo -e "\033[38;5;148m           (/\\/ \\ \\   /\\ \033[0m"
echo -e "\033[38;5;142m           / /   | \`    \\ \033[0m"
echo -e "\033[38;5;136m           O O   ) /    |\033[0m"
echo -e "\033[38;5;130m           \`-^--'\`<     '\033[0m"
echo -e "\033[38;5;124m          (_.)  _  )   /\033[0m"
echo -e "\033[38;5;124m           \`.___/'    /\033[0m"
echo -e "\033[38;5;124m             \`-----' /\033[0m"
echo -e "\033[38;5;160m<----.     __ / __   \\ \033[0m"
echo -e "\033[38;5;160m<----|====O)))==) \\) /====\033[0m"
echo -e "\033[38;5;160m<----'    \`--' \`.__,' \\  \033[0m"
echo -e "\033[38;5;166m             |        |\033[0m"
echo -e "\033[38;5;172m              \\       /\033[0m"
echo -e "\033[38;5;178m        ______( (_  / \\______\033[0m"
echo -e "\033[38;5;184m      ,'  ,-----'   |        \\ \033[0m"
echo -e "\033[38;5;190m      \`--{__________)        \/\033[0m"

sudo systemctl enable wazuh-manager
sudo systemctl start wazuh-manager

echo "___________________________"
echo
echo -e "\e[1;5;7;43m Starting File beat\e[0m"
echo "___________________________"

sudo systemctl enable filebeat
sudo systemctl start filebeat


echo "___________________________"
echo
echo -e "\e[1;5;7;43m Starting Wazuh Dashboard\e[0m"
echo "___________________________"

sudo systemctl enable wazuh-dashboard
sudo systemctl start wazuh-dashboard

echo "___________________________"
echo
echo -e "\e[1;5;7;43m Starting SSH Service\e[0m"
echo "___________________________"

sudo systemctl restart ssh


echo "__________________"
echo
echo -e "\e[1;5;7;43m Done\e[0m"
echo "__________________"
```