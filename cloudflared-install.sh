#!/bin/sh
set -e

echo "Are you sure you wish to disable the default DNS server and install cloudflared proxy?" 
read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    echo "Starting configuration" 
else
    echo "exit cloudflared-installer"
	exit 1
fi

echo "removing dns server" 
configure
delete service dns forwarding
commit
save
exit

echo "downloading cloudflared binary"
sudo curl https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared --output /usr/local/bin/cloudflared
echo "downloading cloudflared init.d script"
sudo curl https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared-dns --output /etc/init.d/cloudflared-dns
echo "setting execute permission on /usr/local/bin/cloudflared"
sudo chmod +x /usr/local/bin/cloudflared
echo "setting execute permission on /etc/init.d/cloudflared-dns"
sudo chmod +x /etc/init.d/cloudflared-dns
echo "starting cloudflared-dns"
/etc/init.d/cloudflared-dns start

echo "cloudflared has been installed"
