#!/bin/bash
# 判断本机的80端口是否开启，
# 如发现端口不存在，则重启httpd服务
# 邮件警告以后再做
# 可以做个死循环，让其每一分钟执行一次该脚本

#---------------------------------------------------------------

# 由于本机没有httpd服务，所以改用transmission-daemon服务，端口为9091

# ---------------------------------------------------------------
while true
do
d=`date +%F--%T`
if netstat -lntp | grep -q ":9091 "  # -q表示quiet，不输出任何内容，9091后面有个空格，精确匹配，以防出现90912类似的端口
then
	echo "$d:transmission服务已开启！"
	sleep 60
	continue
fi
if [ `pgrep -l transmission-da | wc -l` -eq 0 ];then
	echo "$d:transmission服务尚未开启，现在开启..."
	systemctl start transmission-daemon.service > /dev/null 2>/dev/null
	echo "$d:已开启！"
fi
sleep 60
done




