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
bash <(curl -s https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared-uninstall.sh)
```

## Tested Hardware
* EdgeRouter Lite v1.10.1

## Credits
https://bendews.com/posts/implement-dns-over-https/
