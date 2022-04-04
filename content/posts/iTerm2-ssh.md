---
authors: 95
title: "iTerm2 SSH Connect"
date: 2022-04-04
lastmod: 2022-04-04
toc: false
tags: [macos, linux, ssh, network]
---

Script for Terminal (like iTerm2) to connect SSH using Jump Host w/o input Username and Password

<!--more-->

```sh
#!/usr/bin/expect

set JHOST 127.0.0.1 # 跳板机地址
set JPORT 22 # 跳板机端口
set JUSER u1 # 跳板机用户
set JPWD password1 # 跳板机密码

set HOST www.host.com # 服务器地址
set PORT 22
set USER u2
set PWD password2

spawn ssh $USER@$HOST -p $PORT -o "ProxyJump $JUSER@$JHOST -p $JPORT"

expect {
	"yes/no" {send "yes\r";exp_continue;}
	"$JHOST*" {send "$JPWD\r";exp_continue;}
	"$HOST*" {send "$PWD\r"}
}
interact
```

