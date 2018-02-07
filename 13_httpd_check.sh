#!/bin/bash
# 每隔10s监控httpd的进程数，如大于等于500，则重启apache服务，并检测是否启动成功
# 如启动不成功，则再启动一次，如果不成功次数超过5次，则发邮件给admin，并退出
# 启动成功后，1分钟后再次检测hhttpd进程数，如果成功则重复之前的操作（每10s检查httpd进程数）
# 如果还是大于等于500，则放弃重启，并发邮件给admin，并退出脚本
# 假设apache服务位于/usr/sbin/httpd


check_service() {
	n=0
	for i in `seq 1 5`
	do
		/usr/sbin/httpd -k restart 2>/tmp/apache_err  # 如果发生错误，要把错误内容发送给admin
		if [ $? -ne 0 ];then
			n=`expr $n + 1`
		else
			break
		fi
	done
	if [ $n -eq 5 ];then
		python mail.py "123@qq.com" "httpd service down!" `cat /tmp/apache_err`
		exit
	fi
}

while true
do
	httpd_num=`pgrep -l httpd|wc -l`
	if [ $httpd_num -gt 500 ];then
		/usr/sbin/httpd -k restart >/dev/null 2>/dev/null
		if [ $? -ne 0 ];then
			check_service
		fi
		sleep 60
		httpd_num=`pgrep -l httpd|wc -l`
		if [ $httpd_num -gt 500 ];then
			python mail.py "123@qq.com" "httpd service down!" `cat /tmp/apache_err`
			exit
		fi
	fi
	sleep 10
done
			













