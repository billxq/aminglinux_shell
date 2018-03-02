#!/bin/bash

# 输入网卡名字，显示其ip

ifconfig | grep 'mtu'|awk -F':' '{print $1}' > /tmp/ip.txt
while :
do
	read -p "请输入网卡名称，本机网卡有`cat /tmp/ip.txt | xargs | sed 's/ /:/g'`:" e
	if [ -n $e ];then
		if grep -qw "$e" /tmp/ip.txt;then
			break
		fi
	else
		echo "输入的网卡名字不对！"
		continue
	fi
done

getip() {
	ip_addr=`ifconfig $1 | grep -w 'inet' | awk '{print $2}'`
	echo "$ip_addr"
}

myip=`getip $e`
if [ -z $myip ];then
	echo "网卡$e没有设置ip地址！"
else
	echo "网卡$e的ip地址为：$myip"
fi
