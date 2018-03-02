#!/bin/bash
# 猜数字

num=`echo "$[$RANDOM%100]"`

while :
do
	read -p "请输入一个两位数字：" n
	if [ $n == $num ];then
		echo "恭喜你猜对了！"
		exit
	elif [ $n -lt $num ];then
		echo "小了"
		continue
	elif [ $n -gt $num ];then
		echo "大了"
		continue
	fi
done

