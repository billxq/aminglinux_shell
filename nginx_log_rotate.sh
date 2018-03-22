#!/bin/bash

d=`date -d "-1 days" +%F`  #定义d为前一天的日期，格式为2016-11-24，%F表示full day,相当于%Y-%m-%d
[te -d "-1 days" +%F`  #定义d为前一天的日期，格式为2016-11-24，%F表示full day,相当于%Y-%m-%d
[ -d /export/servers/nginx/logs/preivouslogs ] || mkdir -p /export/servers/nginx/logs/previouslogs   #检查是否存在previouslogs目录，不存在就创建
mv /export/servers/nginx/logs/Discuz_access.log /export/servers/nginx/logs/previouslogs/"$d"_Discuz_access.log  #把前一天的日志转移到previouslogs目录下，并重命名
cd /export/servers/nginx/logs/previouslogs
gzip -f "$d"_Discuz_access.log  # 把刚才的日志压缩，-f表示强制
/etc/init.d/nginx reload >/dev/null  #重新加载nginx，使之重新生成Discuz_access.log文件,并把输出重定向到/dev/null -d /usr/local/nginx/logs/preivouslogs ] || mkdir -p /usr/local/nginx/logs/previouslogs   #检查是否存在previouslogs目录，不存在就创建
mv /usr/local/nginx/logs/Discuz_access.log /usr/local/nginx/logs/previouslogs/"$d"_Discuz_access.log  #把前一天的日志转移到previouslogs目录下，并重命名
cd /usr/local/nginx/logs/previouslogs
gzip -f "$d"_Discuz_access.log  # 把刚才的日志压缩，-f表示强制
/etc/init.d/nginx reload >/dev/null  #重新加载nginx，使之重新生成Discuz_access.log文件,并把输出重定向到/dev/null
