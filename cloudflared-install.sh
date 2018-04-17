#!/bin/sh
set -e

echo "Version 0.2e"
echo "Do you wish to configure the default DNS server and install cloudflared proxy?" 
read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    echo "Starting configuration" 
else
    echo "exit cloudflared-installer"
    exit 1
fi

WORKING_FILE=/etc/init.d/cloudflared
if [ -f $WORKING_FILE ]; then
    echo "Found $WORKING_FILE stopping service"
    sudo $WORKING_FILE stop
    echo "Found /etc/init.d/cloudflared-dns removing file"
    sudo rm $WORKING_FILE
fi

WORKING_FILE=/usr/local/bin/cloudflared
if [ -f $WORKING_FILE ]; then
    echo "Found $WORKING_FILE removing file"
    sudo rm $WORKING_FILE
fi

WORKING_FILE=/etc/cloudflared/config.yml
if [ -f $WORKING_FILE ]; then
    read -r -p "found $WORKING_FILE would you like to install the repository maintainers configuration?? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
            echo "Replacing your configuration. Moving your configuration to /tmp/cloudflared-config.yml-backup"
            sudo mv $WORKING_FILE /tmp/cloudflared-config.yml-backup
        else
            echo "Keeping your configuration."
	fi
fi

WORKING_FILE=/etc/cloudflared
if [ ! -d $WORKING_FILE ]; then
    echo "make folder $WORKING_FILE"
    sudo mkdir $WORKING_FILE
fi

WORKING_FILE=/etc/cloudflared/config.yml
if [ ! -f /etc/cloudflared/config.yml ]; then
    echo "Downloading config.yml"
    sudo /usr/bin/curl --fail https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/config.yml --output $WORKING_FILE
fi

echo "downloading cloudflared binary"
sudo /usr/bin/curl --fail https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared --output /usr/local/bin/cloudflared
echo "setting execute permission on /usr/local/bin/cloudflared"
sudo /bin/chmod +x /usr/local/bin/cloudflared
sudo /usr/local/bin/cloudflared service install
sudo /etc/init.d/cloudflared start

echo "configure dns server" 
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set service dns forwarding cache-size 2500 
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set service dns forwarding options "no-resolv"
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set service dns forwarding options "server=127.0.0.1#5053"
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper commit
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end

echo "cloudflared has been installed"
echo "now you should update your DHCP DNS setting to direct clients to me"
