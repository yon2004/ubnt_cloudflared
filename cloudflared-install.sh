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

if [-f /etc/init.d/cloudflared-dns]; then
    echo "found /etc/init.d/cloudflared-dns stopping service"
	sudo /etc/init.d/cloudflared-dns stop
	echo "found /etc/init.d/cloudflared-dns removing previous version"
	rm /etc/init.d/cloudflared-dns
fi

if [-f /usr/local/bin/cloudflared]; then
	echo "found /usr/local/bin/cloudflared removing previous version"
    rm /usr/local/bin/cloudflared
fi

echo "downloading cloudflared binary"
sudo curl https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared --output /usr/local/bin/cloudflared
echo "downloading cloudflared init.d script"
sudo curl https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared-dns --output /etc/init.d/cloudflared-dns
echo "setting execute permission on /usr/local/bin/cloudflared"
sudo chmod +x /usr/local/bin/cloudflared
echo "setting execute permission on /etc/init.d/cloudflared-dns"
sudo chmod +x /etc/init.d/cloudflared-dns
echo "starting cloudflared-dns"
sudo /etc/init.d/cloudflared-dns start

echo "cloudflared has been installed"
