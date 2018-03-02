#!/bin/bash

while :
do
	read -p "请输入你的名字（大小写字母和数字都可以）：" c
	if echo $c | grep -q '[^0-9A-Za-z]';then
		echo "包含特殊字符，请重新输入！"
		continue
	else
		case $c in
			Q|q)
				exit
				;;
			*)
				echo "$[$RANDOM%100]"
				;;
		esac
	fi
done


