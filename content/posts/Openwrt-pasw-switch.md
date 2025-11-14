---
authors: 95
title: "[Tips] Openwrt"
date: 2025-11-15
lastmod: 2025-11-15
toc: true
tags: [tweaks, tips, linux, openwrt, network]
---

OpenWrt passwall auto switch
<!--more-->

# OpenWrt passwall 定时自动切换节点
## 前言
在使用 OpenWrt 的 passwall 插件时，有时你需要在特定的时间切换到特定节点，除了去后台手动切换，其实还可以在后台通过 uci 命令自动切换节点。  
> UCI（Unified Configuration Interface）是 OpenWrt 操作系统中的一个配置框架。UCI 提供了一种统一的方式来配置网络路由器和嵌入式设备上的各种系统组件，如网络接口、无线设置、防火墙规则等。  
本文将通过 uci 配合 crontab 来达到定时切换指定节点的目的。

## 获取 passwall 配置信息
了解 `uci` 的基本使用方法后，就可以使用 `cat /etc/config/passwall` 命令来查看 passwall 的节点配置信息：

```text
config nodes 'myshunt'
        option remarks '分流总节点'
        option type 'Xray'
        option protocol '_shunt'
        option DirectGame '_direct'
        option ProxyGame '_default'
        option AIGC 'Aqn24Lxv'
        option Streaming '_default'
        option Proxy '_default'
        option Direct '_direct'
        option default_node 'dayndoes'
        option domainStrategy 'AsIs'
        option domainMatcher 'hybrid'
        option preproxy_enabled '0'
```

其中 `myshunt` 是父节点名称，而 `default_node 'dayndoes'` 表示实际使用的默认节点。

该节点对应以下配置：

```text
config nodes 'dayndoes'
        option flow 'xtls-rprx-vision'
        option protocol 'vless'
        option tcp_guise 'none'
        option add_from '导入'
        option port '443'
        option remarks 'test_reality'
        option add_mode '1'
```

通过 remarks（如 test_reality）可以找到实际节点名称（如 dayndoes）。

## 切换默认节点

### 查询当前默认节点
```bash
uci show passwall.myshunt.default_node
```

### 修改默认节点
```bash
# 白天
uci set passwall.myshunt.default_node="dayndoes"
# 夜间
uci set passwall.myshunt.default_node="nightndoes"
```

### 提交并重启服务
```bash
uci commit passwall
/etc/init.d/passwall restart
/etc/init.d/haproxy restart   # 若使用负载均衡
```

## 定时切换节点

### Shell 脚本
创建 `/opt/docker/set_passwall.sh`：

```bash
#!/bin/bash

if [ -z "$1" ]; then
    echo "使用方法: $0 <节点>"
    exit 1
fi

PARAM=$1

uci set passwall.myshunt.default_node="$PARAM"
uci show passwall.myshunt.default_node
uci commit passwall

/etc/init.d/passwall restart

echo "已成功设置 passwall.myshunt.default_node 为 $PARAM 并重启 passwall 服务。"
```

添加执行权限：

```bash
chmod +x /opt/docker/set_passwall.sh
```

### 添加 crontab 定时任务

```cron
0 17 * * * /opt/docker/set_passwall.sh nightndoes >> /opt/docker/logfile.log 2>&1
0 5 * * * /opt/docker/set_passwall.sh dayndoes >> /opt/docker/logfile.log 2>&1
```

## 直接设置 TCP 节点

查询当前 TCP 使用的节点：

```bash
uci show passwall.@global[0].tcp_node
```

切换节点：

```bash
uci set passwall.@global[0].tcp_node="nightndoes"
# 或
uci set passwall.@global[0].tcp_node="dayndoes"
```

提交并重启：

```bash
uci commit passwall
/etc/init.d/passwall restart
```

## 参考
- https://openwrt.org/zh/docs/guide-user/base-system/uci  
- https://openwrt.org/zh/docs/techref/uci  
