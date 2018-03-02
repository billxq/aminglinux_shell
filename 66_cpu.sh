#!/bin/bash

cpu=`grep  'vendor_id' /proc/cpuinfo | awk -F ': ' '{print $2}' | head -n1`

if [ $cpu == "GenuineIntel" ];then
	echo "Intel 公司！"
elif [ $cpu == "AuthenticAMD" ];then
	echo "AMD 公司！"
else
	echo "非主流厂商！"
fi
