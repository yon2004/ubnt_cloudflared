# ubnt_cloudflared
This script will install cloudflared dns-proxy on ubiquiti edgemax router series and possibly the UniFi® Security Gateway.

## Guide
### Install
in a ssh session run the following command  
```sh
bash <(curl -s https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared-install.sh)
```

### Uninstall
To go back to using the builtin DNS do the following.  
```sh
sudo /etc/init.d/cloudflared-dns stop  
sudo rm /etc/init.d/cloudflared-dns
sudo rm /usr/local/bin/cloudflared
```
Configure DNS in the webUI and dnsmasq will start after you save your configuration.
    
### Notes
when cloudflared is installed do not configure the DNS service in the webUI without first uninstalling cloudflared as both services use port 53.

## Tested Hardware
* EdgeRouter Lite v1.10.1

## Credits
https://bendews.com/posts/implement-dns-over-https/
