#!/bin/bash
# LNMP环境，监控是否出现502状态码，如果出现10次以上
# 则重启php-fpm服务（一般可以解决），监控502的方法是
# 查看访问日志，假设位于：/data/log/access.log
# 脚本设为死循环，每10s执行一次

log=/data/log/access.log
N=10  # 设定一个阈值，即502出现的次数

while :
do
	tail -n 300 $log > /tmp/acess.log  # 每10s日志产生约300行，把这300行加入到一个临时文件 
	cnt_502=`grep -c '502" ' /tmp/access.log`  # 502"后面有个空格，为了更精确匹配到
	if [ $cnt_502 -gt $N ];then
		/etc/init.d/php-fpm restart 2>/dev/null # 重启php-fpm服务
		sleep 60  # 重启后休眠1分钟
	fi
sleep 10 # 休眠10s，然后再执行这个循环脚本
done	
