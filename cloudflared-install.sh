#!/bin/sh
set -e

echo "Version 0.2d"
echo "Do you wish to configure the default DNS server and install cloudflared proxy?" 
read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    echo "Starting configuration" 
else
    echo "exit cloudflared-installer"
    exit 1
fi

echo "configure dns server" 
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set service dns forwarding cache-size 2500 
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set service dns forwarding options "no-resolv"
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set service dns forwarding options "server=127.0.0.1#5053"
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper commit
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end

if [ -f /etc/init.d/cloudflared-dns ]; then
    echo "found /etc/init.d/cloudflared-dns stopping service"
    sudo /etc/init.d/cloudflared-dns stop
    echo "found /etc/init.d/cloudflared-dns removing previous version"
    sudo rm /etc/init.d/cloudflared-dns
fi

if [ -f /usr/local/bin/cloudflared ]; then
    echo "found /usr/local/bin/cloudflared removing previous version"
    sudo rm /usr/local/bin/cloudflared
fi

if [ -f /etc/cloudflared/config.yml ]; then
    read -r -p "found /etc/cloudflared/config.yml would you like to install the repository maintainers configuration?? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
            echo "Replacing your configuration. Moving your configuration to /tmp/cloudflared-config.yml-backup"
            sudo mv /etc/cloudflared/config.yml /tmp/cloudflared-config.yml-backup
        else
            echo "Keeping your configuration."
	fi
    sudo rm /usr/local/bin/cloudflared
fi

if [ ! -d /etc/cloudflared ]; then
    echo "make folder /etc/cloudflared"
    sudo mkdir /etc/cloudflared
fi

if [ ! -f /etc/cloudflared/config.yml ]; then
    echo "Downloading config.yml"
    sudo /usr/bin/curl https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/config.yml --output /etc/cloudflared/config.yml
fi

echo "downloading cloudflared binary"
sudo /usr/bin/curl https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared --output /usr/local/bin/cloudflared
echo "setting execute permission on /usr/local/bin/cloudflared"
sudo /bin/chmod +x /usr/local/bin/cloudflared
sudo /usr/local/bin/cloudflared service install
sudo /etc/init.d/cloudflared-dns start

echo "cloudflared has been installed"
echo "now you should update your DHCP DNS setting to direct clients to me"
