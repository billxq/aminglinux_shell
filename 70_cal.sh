#!/bin/bash

is_int() {
	n=`echo "$1" | sed 's/[0-9]//g'`
	if [ ! -z $n ];then
		echo "$1 is not a number!"
	fi
}


if is_int $1;then
	exit
fi

if is_int $3;then
	exit
fi


case $2 in
	+)
		echo "$1+$2"|bc
		;;
	-)
		echo "$1-$2"|bc
		;;
	*)
		echo "$1*$2"|bc
		;;
	/)
		echo "scale=2;$1/$2"|bc
		;;
	*)
		echo "运算符错误！"
		exit
		;;
esac
