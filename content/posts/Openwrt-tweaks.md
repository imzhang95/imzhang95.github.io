---
author: 95
title: "[Tweaks] Openwrt"
date: 2022-03-10
lastmod: 2022-03-12
toc: true
tags: [tweaks, linux, openwrt, network]
---

Tweaking my Router (Openwrt in PVE) and some records..
<!--more-->

## System deployment

### Mount disk

1. Upload img - Get file address  
2. `qm importdisk 100 /var/lib/vz/template/iso/openwrt.img local`  
3. Edit VM - HDD SATA  


### Change LAN ip

1. `vi /etc/config/network`  
2. `/etc/init.d/network restart`  

## System config

### Wechat related

`http://dns.weixin.qq.com/cgi-bin/micromsg-bin/newgetdns`

```html
101.32.104.0/24
101.32.118.0/24
101.32.133.0/24
129.226.3.0/24
43.156.86.0/24
```

