#!/bin/sh
set -e

echo "Version 0.2"
echo "Do you wish to remove cloudflared proxy and changes made to the DNS server?" 
read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    echo "Starting uninstall" 
else
    echo "exit cloudflared-uninstaller"
	exit 1
fi

echo "revert configuration changes"
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper delete service dns forwarding options "no-resolv"
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper delete service dns forwarding options "server=127.0.0.1#5053"
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper commit
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end

echo "Remove cloudflared files"
sudo /etc/init.d/cloudflared stop
sudo rm /etc/init.d/cloudflared
sudo rm /usr/local/bin/cloudflared

echo "uninstalled cloudflared"
