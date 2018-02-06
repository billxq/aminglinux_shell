#!/bin/bash

# 该脚本实现如下功能：输入一个数字，然后运行一个命令，显示如下：
# *cmd menu** 1 - date 2 - ls  3 - who 4 - pwd
# 输入1，执行date命令，以此类推

cat << EOF
###################################################
# *cmd menu** 1 - date 2 - ls  3 - who 4 - pwd#####
###################################################
EOF

read -p "Please input your number[1-4]: " n
n2=`echo $n|sed 's/[0-9]//'`
if [ ! -z $n2 ];then
	echo "Please input a number from 1-4!"
	exit
fi	

case $n in
	1)
		date
	;;
	2)
		ls
	;;
	3)
		who
	;;
	4)
		pwd
	;;
	*)
		echo "Please input a number from 1-4!"
	;;
esac	
