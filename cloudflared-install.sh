#!/bin/sh
set -e

echo "Version 0.2c"
echo "Do you wish to configure the default DNS server and install cloudflared proxy?" 
read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    echo "Starting configuration" 
else
    echo "exit cloudflared-installer"
	exit 1
fi

echo "removing dns server" 
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set service dns forwarding cache-size 10000 
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

echo "downloading cloudflared binary"
sudo /usr/bin/curl https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared --output /usr/local/bin/cloudflared
echo "downloading cloudflared init.d script"
sudo /usr/bin/curl https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared-dns --output /etc/init.d/cloudflared-dns
echo "setting execute permission on /usr/local/bin/cloudflared"
sudo /bin/chmod +x /usr/local/bin/cloudflared
echo "setting execute permission on /etc/init.d/cloudflared-dns"
sudo /bin/chmod +x /etc/init.d/cloudflared-dns
sudo /etc/init.d/cloudflared-dns start

echo "cloudflared has been installed"
echo "now you should update your DHCP DNS setting to direct clients to me"
