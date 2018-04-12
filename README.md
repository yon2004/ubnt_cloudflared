# ubnt_cloudflared
A installer that installs cloudflared dns-proxy on edge router lite.

## guide
### disable dnsmasq
  configure  
  delete service dns forwarding  
  commit  
  save  
  exit  

### download and start cloudflared
  sudo curl https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared --output /usr/local/bin/cloudflared  
  sudo curl https://raw.githubusercontent.com/yon2004/ubnt_cloudflared/master/cloudflared-dns --output /etc/init.d/cloudflared-dns  
  chmod +x /usr/local/bin/cloudflared  
  chmod +x /etc/init.d/cloudflared-dns  
  /etc/init.d/cloudflared-dns start  
