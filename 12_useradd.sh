#!/bin/bash

# 批量创建user_00到user_09 这10个用户，并且设置一个10位数的随机密码
# 密码要求包含大小写字母及数字，把密码存入一个日志文件里


for i in `seq -w 00 09`;do   # -w可以让序列宽度保持一致
	useradd user_$i
	password=`mkpasswd -l 10 -s 0`
	echo "$password" >> /tmp/password.log
	echo  $password | passwd --stdin user_$i 
	# echo -e "$password\n$password" | passwd user_$i  # 这种方法也可以
done
