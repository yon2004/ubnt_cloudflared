# ubnt_cloudflared
A installer that installs cloudflared dns-proxy on edge router lite.

## guide
### install
in a ssh session run the following command  
    bash <(curl -s https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared-install.sh)

### uninstall
If you wish to go back to using the builtin DNS do the following.
    sudo /etc/init.d/cloudflared-dns stop  
    sudo rm /etc/init.d/cloudflared-dns
    
### notes
when cloudflared is installed do not configure the DNS service in the webUI without first uninstalling cloudflared as both services use port 53.

## credits
https://bendews.com/posts/implement-dns-over-https/
