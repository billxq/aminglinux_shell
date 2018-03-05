#!/bin/bash
while :
do
    read -p "请输入一个数字：" n
    a=`echo $n|sed 's/[0-9]//g'`
    if [ ! -z $a ];then
        echo "不是数字，重新输入"
    else
        break
    fi
done


for i in `seq $n`;do
    for j in `seq $n`;do
        echo -n "X"
    done
    echo
done
