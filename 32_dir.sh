#!/bin/bash
# 脚本可以带或不带参数，参数是一个目录
# 如果带参数，就显示参数目录下的子目录
# 否则，显示当前目录下的子目录


if [ $# -eq 0 ];then
	echo "当前目录下的子目录有："
	echo "`ls -ld`"
else
	for i in `seq 1 $#`;do
		a=$i
		echo "${!a}目录下包含的子目录是"   # shell中，不支持 $$i的写法，如echo $$3，所以要做特殊处理如下a=$i,${!a}
		find ${!a} -type d
		echo
	done
fi
