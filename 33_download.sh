#!/bin/bash
# 第一个参数是url，即可下载的网址，第二个参数是目录
# 如果目录不存在，提示用户创建，如果用户选择不创建
# 则返回51给调用脚本
# 如果目录存在，下载结束后，如果成功，返回0，否则52


while :
do
	if [ $# -ne 2 ];then
		echo "必需输入两个参数，一个是url，一个是下载目录！"
		exit
	else
		break
	fi
done


download() {
if [ !-d $2];then
	while :
	do
		read -p "输入的目录不存在，是否创建[Y/N]:" n
		case $n in
			Y|y)
				mkdir -p $2
				break
				;;
			N|n)
				return 51
				;;
			*)
				echo "只能输入Y|N"
				continue
				;;
		esac
	done
fi

cd $2
wget $1
if [ $? -ne 0 ];then
	return 52
else
	return 0
fi
}

download $1 $2


