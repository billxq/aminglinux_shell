#!/bin/bash
#监测远程主机的存活状态，如果宕机，则发一封邮件给自己

host=104.224.135.132
mail_addr=myemail@qq.com
while true
do
	pkg_loss=`ping -c3 $host 2>/dev/null| grep 'received'|awk -F'received, |%' '{print $2}'`
	if [ -z $pkg_loss ];then
		echo "Something wrong with the script. Check it."
		exit
	fi
	if [ $pkg_loss -gt 20 ];then
		echo "The host is down!Please check it."
		python ./mail.py $mail_addr '$host down' '$host is down!'
	else
		echo "The host is ok!"
	fi
	sleep 30
done




