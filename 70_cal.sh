#!/bin/bash

is_int() {
	n=`echo "$1" | sed 's/[0-9]//g'`
	if [ ! -z $n ];then
		echo "$1 is not a number!"
        exit
	fi
}


is_int $1
is_int $3

case $2 in
	+)
		echo "$1+$3"|bc
		;;
	-)
		echo "$1-$3"|bc
		;;
	\*)
		echo "$1*$3"|bc
		;;
	/)
		echo "scale=2;$1/$3"|bc
		;;
	*)
		echo "运算符错误！"
		exit
		;;
esac
