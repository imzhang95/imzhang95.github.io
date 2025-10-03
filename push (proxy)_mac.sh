#!/bin/sh
export http_proxy=socks5://127.0.0.1:8080
export https_proxy=$http_proxy
git add .
git commit -m "$(date +%Y%m%d)"
git push -u origin develop
unset http_proxy && unset https_proxy 
exit 0
